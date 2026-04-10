include "globals.mzn";

% Parameters
int: N = 5;
set of int: CITIES = 1..N; % 1=E, 2=F, 3=G, 4=H, 5=I

array[CITIES, CITIES] of int: cost =
  [|   0,  37,  72,  66,  33
   |  37,   0,  26,  56, 100
   |  72,  26,   0,  49,  32
   |  66,  56,  49,   0,  13
   |  33, 100,  32,  13,   0
   |];

% Variables
array[CITIES] of var CITIES: succ;
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