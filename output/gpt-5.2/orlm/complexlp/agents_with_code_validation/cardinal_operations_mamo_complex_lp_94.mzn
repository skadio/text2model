include "globals.mzn";

% Parameters
int: n = 4;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
 [|  0, 94, 34, 87
  | 94,  0, 62, 87
  | 34, 62,  0, 97
  | 87, 87, 97,  0 |];

% Variables
array[CITIES] of var CITIES: succ;  % successor city for each city in the tour
var int: total_cost;

% Constraints
% No self loops
constraint forall(i in CITIES)(succ[i] != i);

% Ensure succ forms a single Hamiltonian cycle (no subtours)
constraint circuit(succ);

% Objective: compute total travel cost along successor edges
constraint total_cost = sum(i in CITIES)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];