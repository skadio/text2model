include "globals.mzn";

% Parameters
int: n = 5;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
  [| 0, 87, 41, 55, 57
   | 87, 0, 80, 33, 40
   | 41, 80, 0, 90, 42
   | 55, 33, 90, 0, 53
   | 57, 40, 42, 53, 0 |];

int: max_cost = max([cost[i,j] | i in CITIES, j in CITIES]);
int: UB = n * max_cost;

% Variables
array[CITIES] of var CITIES: succ;
array[CITIES] of var 0..UB: dist;
var 0..UB: total_cost;

% Constraints
constraint circuit(succ);

constraint forall(i in CITIES) (
  dist[i] = cost[i, succ[i]]
);

constraint total_cost = sum(i in CITIES)(dist[i]);

% Objective
solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];