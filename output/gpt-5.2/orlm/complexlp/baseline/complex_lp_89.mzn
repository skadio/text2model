include "globals.mzn";

int: n = 5;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
[
| 0, 82, 76, 92, 59 |
| 82, 0, 98, 58, 82 |
| 76, 98, 0, 26, 74 |
| 92, 58, 26, 0, 96 |
| 59, 82, 74, 96, 0  |
];

% Fix a start city to break symmetry (tour is a cycle).
int: start = 1;

array[CITIES] of var CITIES: succ;

constraint forall(i in CITIES)(succ[i] != i);
constraint circuit(succ);

var int: total_cost = sum(i in CITIES)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "Minimum total cost = ", show(total_cost), "\n",
  "Successor representation (city -> next):\n",
  concat([show(i) ++ " -> " ++ show(succ[i]) ++ "\n" | i in CITIES])
];