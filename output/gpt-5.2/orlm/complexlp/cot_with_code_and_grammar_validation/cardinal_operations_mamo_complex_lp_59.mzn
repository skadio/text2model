include "globals.mzn";

% Parameters
int: n = 5;
set of int: CITIES = 1..n; % 1=E, 2=F, 3=G, 4=H, 5=I

array[CITIES, CITIES] of int: cost =
  [|   0, 50, 48, 99, 91
   |  50,  0, 57, 84, 72
   |  48, 57,  0, 46, 86
   |  99, 84, 46,  0, 29
   |  91, 72, 86, 29,  0
  |];

% Variables
array[CITIES] of var CITIES: succ; % successor city in the tour
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