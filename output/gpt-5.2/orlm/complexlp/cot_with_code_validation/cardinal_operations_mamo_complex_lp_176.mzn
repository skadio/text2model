% Facility location + transportation (capacitated) - embedded data

int: NCenters = 7;
int: NStores  = 5;

set of int: C = 1..NCenters;
set of int: S = 1..NStores;

array[C] of int: openCost = [151000, 192000, 114000, 171000, 160000, 120000, 182000];
array[C] of int: capacity = [1697, 891, 1755, 1308, 1575, 834, 1005];
array[S] of int: demand   = [715, 413, 641, 745, 964];

array[C, S] of int: transCost =
  [| 3, 3, 5, 4, 3
   | 5, 2, 4, 2, 4
   | 5, 1, 4, 2, 5
   | 4, 1, 1, 3, 3
   | 2, 4, 4, 3, 4
   | 4, 1, 3, 5, 3
   | 5, 1, 2, 4, 1 |];

int: totalDemand = sum(s in S)(demand[s]);

% Variables
array[C] of var bool: open;
array[C, S] of var 0..totalDemand: ship;

% Constraints: meet demand
constraint forall(s in S) (
  sum(c in C)(ship[c,s]) = demand[s]
);

% Constraints: respect capacity if opened (use open as reified indicator)
constraint forall(c in C) (
  sum(s in S)(ship[c,s]) <= capacity[c] * (open[c])
);

% Objective (avoid an explicit totalCost var to reduce solving overhead)
solve minimize
  sum(c in C)(openCost[c] * (open[c])) +
  sum(c in C, s in S)(transCost[c,s] * ship[c,s]);

% Optional output
output [
  "TotalCost = ",
  show(
    sum(c in C)(openCost[c] * (open[c])) +
    sum(c in C, s in S)(transCost[c,s] * ship[c,s])
  ),
  "\nOpen centers: ",
  show([open[c] | c in C]),
  "\n"
];