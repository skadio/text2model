% Facility location / transportation with capacities
% Data embedded as requested

int: NCenters = 4;
int: NStores  = 6;

set of int: C = 1..NCenters;
set of int: S = 1..NStores;

array[C] of int: openCost = [151000, 192000, 114000, 171000];

array[C, S] of int: transCost =
  [| 5, 5, 2, 3, 3, 3
   | 5, 4, 3, 5, 2, 4
   | 2, 4, 5, 1, 4, 2
   | 5, 4, 1, 1, 3, 3 |];

array[S] of int: demand   = [910, 875, 589, 962, 966, 643];
array[C] of int: capacity = [1631, 1954, 1446, 820];

int: totalDemand = sum(s in S)(demand[s]);

% Decision variables
array[C] of var bool: open;
array[C, S] of var 0..totalDemand: ship;

% Constraints: meet every store's demand exactly
constraint forall(s in S)(
  sum(c in C)(ship[c, s]) = demand[s]
);

% Capacity only if open
constraint forall(c in C)(
  sum(s in S)(ship[c, s]) <= capacity[c] * bool2int(open[c])
);

% Tight linking (optional but helps): if closed, no shipping to any store
constraint forall(c in C, s in S)(
  ship[c, s] <= demand[s] * bool2int(open[c])
);

% Objective (direct; avoid extra totalCost var / large bounds)
solve minimize
  sum(c in C)(openCost[c] * bool2int(open[c])) +
  sum(c in C, s in S)(transCost[c, s] * ship[c, s]);

output [
  "Total cost = ",
  show(
    sum(c in C)(openCost[c] * bool2int(open[c])) +
    sum(c in C, s in S)(transCost[c, s] * ship[c, s])
  ),
  "\nOpen centers: ",
  show([bool2int(open[c]) | c in C]),
  "\n"
];