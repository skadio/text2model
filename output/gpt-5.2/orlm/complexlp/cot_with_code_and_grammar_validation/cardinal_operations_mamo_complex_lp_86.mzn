include "globals.mzn";

% Parameters
int: n = 5;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
 [| 0, 73, 39, 79, 38
  | 73, 0, 30, 46, 29
  | 39, 30, 0, 88, 57
  | 79, 46, 88, 0, 59
  | 38, 29, 57, 59, 0
  |];

% Variables
array[CITIES] of var CITIES: next;
var int: total_cost;

% Constraints
constraint circuit(next);
constraint forall(i in CITIES)(next[i] != i);

constraint total_cost = sum(i in CITIES)(cost[i, next[i]]);

% Objective
solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "next = ", show(next), "\n"
];