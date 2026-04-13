include "globals.mzn";

% Parameters
int: nCities = 5;                        % number of cities (E..I)
set of int: CITIES = 1..nCities;         % city indices: 1=E, 2=F, 3=G, 4=H, 5=I

array[CITIES, CITIES] of int: cost = array2d(CITIES, CITIES,
[
  % row 1 (from E): to 1..5
   0, 35, 90, 23, 62,
  % row 2 (from F)
  35,  0, 53, 58, 46,
  % row 3 (from G)
  90, 53,  0, 28, 91,
  % row 4 (from H)
  23, 58, 28,  0, 77,
  % row 5 (from I)
  62, 46, 91, 77,  0
]);

int: maxCost = max([cost[i,j] | i in CITIES, j in CITIES]);

% Variables
array[CITIES] of var CITIES: next;        % successor
var 0..maxCost*nCities: totalCost;

% Constraints
constraint circuit(next);
constraint totalCost = sum(i in CITIES)(cost[i, next[i]]);

% Objective
solve minimize totalCost;

output [
  "totalCost = ", show(totalCost), "\n",
  "next = ", show(next), "\n"
];