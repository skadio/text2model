include "globals.mzn";

% Parameters
int: nCities = 4;
set of int: CITIES = 1..nCities;

array[CITIES, CITIES] of int: cost =
  [| 0,  29, 97, 72
   | 29, 0,  69, 52
   | 97, 69, 0,  91
   | 72, 52, 91, 0  |];

% Variables
array[CITIES] of var CITIES: next;   % successor city
array[CITIES] of var CITIES: prev;   % predecessor city
var int: totalCost;

% Constraints
constraint circuit(next);
constraint inverse(next, prev);
constraint totalCost = sum(i in CITIES)(cost[i, next[i]]);

% Objective
solve minimize totalCost;

output [
  "totalCost = ", show(totalCost), "\n",
  "next = ", show(next), "\n"
];