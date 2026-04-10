include "globals.mzn";

% Parameters
int: n = 6;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
[
|  0, 86, 81, 64, 65, 24
| 86,  0, 44, 80, 91, 23
| 81, 44,  0, 15, 25, 89
| 64, 80, 15,  0, 89, 41
| 65, 91, 25, 89,  0, 29
| 24, 23, 89, 41, 29,  0
];

% Decision variables: successor in the tour
array[CITIES] of var CITIES: succ;

% Total cost
var int: total_cost = sum(i in CITIES)(cost[i, succ[i]]);

% Constraints: one Hamiltonian circuit
constraint circuit(succ);

% Objective
solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];