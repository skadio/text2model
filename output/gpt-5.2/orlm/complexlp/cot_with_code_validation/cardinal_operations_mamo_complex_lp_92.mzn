include "globals.mzn";

% Parameters
int: N = 6;
set of int: CITIES = 1..N;

array[CITIES, CITIES] of int: cost =
[|  0, 43, 39, 97, 84, 67
 | 43,  0, 18, 92, 27, 51
 | 39, 18,  0, 84, 60, 15
 | 97, 92, 84,  0, 42, 32
 | 84, 27, 60, 42,  0, 18
 | 67, 51, 15, 32, 18,  0
 |];

int: max_cost = max([cost[i,j] | i in CITIES, j in CITIES]);
int: UB = N * max_cost;

% Variables
array[CITIES] of var CITIES: succ;     % successor city in the tour
var 0..UB: total_cost;

% Constraints
constraint forall(i in CITIES)(succ[i] != i);
constraint circuit(succ);

constraint total_cost = sum(i in CITIES)(cost[i, succ[i]]);

% Objective
solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];