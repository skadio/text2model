include "globals.mzn";

% Parameters
int: N = 4;
set of int: CITIES = 1..N; % 1=E, 2=F, 3=G, 4=H

array[CITIES, CITIES] of int: cost =
  [|  0, 17, 52, 79
   | 17,  0, 15, 71
   | 52, 15,  0, 54
   | 79, 71, 54,  0 |];

% Variables
array[CITIES] of var CITIES: succ;
var int: total_cost;

% Constraints
constraint circuit(succ);

constraint total_cost = sum(i in CITIES)(cost[i, succ[i]]);

% Objective
solve minimize total_cost;