include "globals.mzn";

% Parameters
int: n = 4;
set of int: N = 1..n; % 1=E, 2=F, 3=G, 4=H

array[N, N] of int: cost =
  [| 0, 62, 51, 50
   | 62, 0, 42, 69
   | 51, 42, 0, 11
   | 50, 69, 11, 0 |];

% Variables
array[N] of var N: succ;
var int: total_cost;

% Constraints
constraint circuit(succ);
constraint total_cost = sum(i in N)(cost[i, succ[i]]);

% Objective
solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "succ=", show(succ), "\n"
];