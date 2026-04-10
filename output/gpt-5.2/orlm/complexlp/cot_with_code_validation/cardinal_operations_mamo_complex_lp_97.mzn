include "globals.mzn";

% Parameters
int: n = 4;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
  [| 0, 76, 17, 24
   | 76, 0, 84, 11
   | 17, 84, 0, 90
   | 24, 11, 90, 0 |];

% Variables
array[CITIES, CITIES] of var 0..1: x;   % x[i,j] = 1 if travel from i to j
array[CITIES] of var CITIES: succ;      % successor city (for circuit)
var int: total_cost;

% Constraints
constraint forall(i in CITIES)(x[i,i] = 0);

constraint forall(i in CITIES)(
  sum(j in CITIES)(x[i,j]) = 1
);

constraint forall(j in CITIES)(
  sum(i in CITIES)(x[i,j]) = 1
);

constraint forall(i in CITIES)(
  succ[i] = sum(j in CITIES)(j * x[i,j])
);

constraint circuit(succ);

constraint total_cost = sum(i in CITIES, j in CITIES)(cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];