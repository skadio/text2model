include "globals.mzn";

% Parameters
int: nCities = 4;
set of int: Cities = 1..nCities; % 1=A, 2=B, 3=C, 4=D

array[Cities, Cities] of int: cost =
[
|  0, 61, 65, 63
| 61,  0, 94, 31
| 65, 94,  0, 19
| 63, 31, 19,  0
];

% Decision variables
array[Cities] of var Cities: succ; % successor of each city in the tour

% Total tour cost
var int: total_cost = sum(i in Cities)(cost[i, succ[i]]);

% Constraints: single Hamiltonian circuit
constraint circuit(succ);

% Objective
solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];