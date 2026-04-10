include "globals.mzn";

% Parameters
int: n = 4;
set of int: Cities = 1..n; % 1=A, 2=B, 3=C, 4=D

array[Cities, Cities] of int: cost =
[| 0, 19, 45, 30
 | 19, 0, 89, 46
 | 45, 89, 0, 11
 | 30, 46, 11, 0 |];

% Variables
array[Cities] of var Cities: succ;  % successor city for each city in the tour
var 0..sum(i,j in Cities)(cost[i,j]): total_cost;

% Constraints
constraint forall(i in Cities)(succ[i] != i);
constraint circuit(succ);

constraint total_cost = sum(i in Cities)(cost[i, succ[i]]);

% Objective
solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];