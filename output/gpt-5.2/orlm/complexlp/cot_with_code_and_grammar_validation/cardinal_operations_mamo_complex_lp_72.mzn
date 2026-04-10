include "globals.mzn";

% Parameters
int: n = 5;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
  [|  0, 58, 15, 75, 91
   | 58,  0, 54, 85, 11
   | 15, 54,  0, 28, 61
   | 75, 85, 28,  0, 47
   | 91, 11, 61, 47,  0
  |];

int: maxCost = max([cost[i,j] | i, j in CITIES]);

% Variables
array[CITIES] of var CITIES: succ;
array[CITIES] of var 0..maxCost: arcCost;
var 0..(n * maxCost): totalCost;

% Constraints
constraint circuit(succ);

constraint forall(i in CITIES) (
  arcCost[i] = cost[i, succ[i]]
);

constraint totalCost = sum(i in CITIES)(arcCost[i]);

% Objective
solve minimize totalCost;

output [
  "totalCost = ", show(totalCost), "\n",
  "succ = ", show(succ), "\n"
];