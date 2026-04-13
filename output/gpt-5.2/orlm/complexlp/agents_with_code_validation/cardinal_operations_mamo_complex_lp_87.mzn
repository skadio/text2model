include "globals.mzn";

% Parameters
int: nCities = 5;
set of int: CITIES = 1..nCities;

% Travel cost matrix (cost[i,j] = cost to go from city i to city j)
array[CITIES, CITIES] of int: cost = array2d(CITIES, CITIES, [
   0, 46, 63, 54, 45,
  46,  0, 48, 50, 51,
  63, 48,  0, 31, 64,
  54, 50, 31,  0, 94,
  45, 51, 64, 94,  0
]);

% Variables
array[CITIES] of var CITIES: succ;   % succ[i] = next city visited after i
var int: totalCost;

% Constraints
constraint circuit(succ);
constraint totalCost = sum(i in CITIES) (cost[i, succ[i]]);

% Objective
solve minimize totalCost;

output [
  "totalCost = ", show(totalCost), "\n",
  "succ = ", show(succ), "\n"
];