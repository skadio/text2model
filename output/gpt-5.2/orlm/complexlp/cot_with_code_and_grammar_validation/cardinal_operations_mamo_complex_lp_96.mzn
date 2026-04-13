include "globals.mzn";

% Parameters
int: n = 6;
set of int: Cities = 1..n;

array[Cities, Cities] of int: cost =
  [|  0, 21, 43, 25, 38, 91
   | 21,  0, 32, 25, 16, 14
   | 43, 32,  0, 96, 71, 98
   | 25, 25, 96,  0, 53, 22
   | 38, 16, 71, 53,  0,100
   | 91, 14, 98, 22,100,  0 |];

int: maxCost = max([cost[i,j] | i in Cities, j in Cities]);
int: UB = n * maxCost;

% Variables
array[Cities] of var Cities: succ;
var 0..UB: totalCost;

% Constraints
constraint circuit(succ);

constraint totalCost = sum(i in Cities)(cost[i, succ[i]]);

% Objective
solve minimize totalCost;

output [
  "totalCost = ", show(totalCost), "\n",
  "succ = ", show(succ), "\n"
];