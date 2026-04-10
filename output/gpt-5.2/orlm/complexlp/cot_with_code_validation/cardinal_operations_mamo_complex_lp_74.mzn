include "globals.mzn";

% Parameters
int: n = 4;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
[|  0, 29, 97, 72
 | 29,  0, 69, 52
 | 97, 69,  0, 91
 | 72, 52, 91,  0 |];

% Variables: successor representation of a Hamiltonian cycle
array[CITIES] of var CITIES: succ;

var int: total_cost;

% Constraints
constraint circuit(succ);

constraint total_cost = sum(i in CITIES)(cost[i, succ[i]]);

% Objective
solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];