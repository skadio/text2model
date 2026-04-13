include "globals.mzn";

% Parameters
int: nCities = 6;
set of int: CITIES = 1..nCities;

array[CITIES, CITIES] of int: cost =
  [|  0, 43, 39, 97, 84, 67
   | 43,  0, 18, 92, 27, 51
   | 39, 18,  0, 84, 60, 15
   | 97, 92, 84,  0, 42, 32
   | 84, 27, 60, 42,  0, 18
   | 67, 51, 15, 32, 18,  0 |];

int: maxCost = max([cost[i,j] | i in CITIES, j in CITIES]);
int: maxTotalCost = nCities * maxCost;

% Decision variables
array[CITIES] of var CITIES: succ;      % succ[i] = next city after i
var 0..maxTotalCost: totalCost;

% Constraints
constraint circuit(succ);
constraint totalCost = sum(i in CITIES)(cost[i, succ[i]]);

% Objective
solve minimize totalCost;

output [
  "totalCost = ", show(totalCost), "\n",
  "succ = ", show(succ), "\n"
];