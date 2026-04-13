include "globals.mzn";

% Parameters
int: n = 5;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
array2d(CITIES, CITIES,
[
  0, 73, 39, 79, 38,
  73, 0, 30, 46, 29,
  39, 30, 0, 88, 57,
  79, 46, 88, 0, 59,
  38, 29, 57, 59, 0
]);

% Variables
array[CITIES] of var CITIES: succ;   % successor city for each city
array[CITIES] of var CITIES: pred;   % predecessor city for each city
var int: total_cost;

% Constraints
constraint forall(i in CITIES)(succ[i] != i);
constraint forall(i in CITIES)(pred[i] != i);

constraint all_different(succ);
constraint all_different(pred);

constraint inverse(succ, pred);
constraint circuit(succ);

constraint total_cost = sum(i in CITIES)(cost[i, succ[i]]);

% Objective
solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];