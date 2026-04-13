% Parameters (with values embedded)
int: NCenters = 4;
int: NStores  = 8;

set of int: C = 1..NCenters;
set of int: S = 1..NStores;

array[C] of int: openCost = [151000, 192000, 114000, 171000];
array[C] of int: capacity = [1041, 1576, 1364, 1697];

array[S] of int: demand = [884, 420, 566, 673, 787, 1000, 715, 413];

array[C, S] of int: transCost =
  array2d(C, S,
    [ 5,5,2,3,3,3,5,4,
      3,5,2,4,2,4,5,1,
      4,2,5,4,1,1,3,3,
      2,4,4,3,4,4,1,3 ]);

int: totalDemand = sum(s in S)(demand[s]);

% Variables
array[C] of var bool: open;
array[C, S] of var 0..totalDemand: ship;  % units shipped from center c to store s

% Constraints
constraint
  forall(s in S)(
    sum(c in C)(ship[c,s]) = demand[s]
  );

constraint
  forall(c in C)(
    sum(s in S)(ship[c,s]) <= capacity[c] * bool2int(open[c])
  );

% Objective
var int: totalCost =
    sum(c in C)(openCost[c] * bool2int(open[c]))
  + sum(c in C, s in S)(transCost[c,s] * ship[c,s]);

solve minimize totalCost;

output [
  "Optimal total cost = ", show(totalCost), "\n",
  "Open centers: ", show([bool2int(open[c]) | c in C]), "\n",
  "Shipments (center x store):\n"
] ++
[
  "Center " ++ show(c) ++ ": " ++ show([ship[c,s] | s in S]) ++ "\n"
  | c in C
];