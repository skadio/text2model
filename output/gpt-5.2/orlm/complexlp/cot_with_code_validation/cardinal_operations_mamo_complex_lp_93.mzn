include "globals.mzn";

% Parameters
int: n = 4;
set of int: Cities = 1..n; % 1=A, 2=B, 3=C, 4=D

array[Cities, Cities] of int: cost =
  [|  0, 61, 65, 63
   | 61,  0, 94, 31
   | 65, 94,  0, 19
   | 63, 31, 19,  0 |];

% Variables
array[Cities] of var Cities: succ;
var int: total_cost;

% Constraints
constraint circuit(succ);
constraint total_cost = sum(i in Cities)(cost[i, succ[i]]);

% Objective
solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];