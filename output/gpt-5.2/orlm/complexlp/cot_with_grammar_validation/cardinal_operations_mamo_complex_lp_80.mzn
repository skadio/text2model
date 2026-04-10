% Parameters
int: n = 4;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
  [| 0, 17, 25, 31
   | 17, 0, 93, 45
   | 25, 93, 0, 95
   | 31, 45, 95, 0 |];

% Variables
array[CITIES] of var CITIES: succ;
var 0..sum(i in CITIES, j in CITIES)(cost[i,j]): total_cost;

% Constraints
constraint forall(i in CITIES)(succ[i] != i);

constraint alldifferent(succ);

constraint
  total_cost =
    sum(i in CITIES)(cost[i, succ[i]]);

include "globals.mzn";
constraint circuit(succ);

% Objective
solve minimize total_cost;