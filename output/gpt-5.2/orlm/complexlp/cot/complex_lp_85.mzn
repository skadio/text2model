% Parameters (with values embedded)
include "globals.mzn";

int: n = 6;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
  [|  0, 63, 62, 49, 58, 38
   | 63,  0, 93, 21, 66, 42
   | 62, 93,  0, 26, 99, 96
   | 49, 21, 26,  0, 73, 80
   | 58, 66, 99, 73,  0, 76
   | 38, 42, 96, 80, 76,  0 |];

% Variables
array[CITIES] of var CITIES: succ;   % successor city for each city
array[CITIES] of var CITIES: pred;   % predecessor city for each city
var 0..100000: total_cost;

% Constraints
constraint forall(i in CITIES)(succ[i] != i);
constraint forall(i in CITIES)(pred[i] != i);

constraint all_different(succ);
constraint all_different(pred);

constraint forall(i in CITIES)(pred[succ[i]] = i);

constraint total_cost = sum(i in CITIES)(cost[i, succ[i]]);

% Objective
solve minimize total_cost;