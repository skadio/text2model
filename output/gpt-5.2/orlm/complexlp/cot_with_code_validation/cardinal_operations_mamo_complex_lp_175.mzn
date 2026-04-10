% Facility location / transportation problem (all data embedded)

% Parameters
int: NCenters = 5;
int: NStores  = 9;

set of int: C = 1..NCenters;
set of int: S = 1..NStores;

array[C] of int: openCost = [151000, 192000, 114000, 171000, 160000];
array[C] of int: capacity = [1825, 1821, 1365, 1929, 1502];
array[S] of int: demand   = [739, 491, 766, 854, 827, 908, 434, 605, 480];

array[C, S] of int: shipCost =
  array2d(C, S,
    [
      5, 2, 3, 3, 3, 5, 4, 3, 5,
      2, 4, 2, 4, 5, 1, 4, 2, 5,
      4, 1, 1, 3, 3, 2, 4, 4, 3,
      4, 4, 1, 3, 5, 3, 5, 1, 2,
      4, 1, 4, 2, 2, 1, 2, 5, 2
    ]
  );

int: totalDemand = sum(s in S)(demand[s]);

% Variables
array[C] of var bool: open;
array[C, S] of var 0..totalDemand: flow;

var int: totalCost;

% Constraints
constraint forall(s in S)(
  sum(c in C)(flow[c, s]) = demand[s]
);

constraint forall(c in C)(
  sum(s in S)(flow[c, s]) <= capacity[c]
);

constraint forall(c in C, s in S)(
  flow[c, s] <= demand[s] * bool2int(open[c])
);

constraint totalCost =
  sum(c in C)(openCost[c] * bool2int(open[c])) +
  sum(c in C, s in S)(shipCost[c, s] * flow[c, s]);

% Objective (problem statement indicates minimization)
solve minimize totalCost;

output [
  "totalCost=", show(totalCost), "\n",
  "open=", show(open), "\n",
  "flow=\n"
] ++ [
  if s = 1 then "" else "" endif ++
  concat([ show(flow[c,s]) ++ if c = NCenters then "\n" else " " endif | c in C ])
  | s in S
];