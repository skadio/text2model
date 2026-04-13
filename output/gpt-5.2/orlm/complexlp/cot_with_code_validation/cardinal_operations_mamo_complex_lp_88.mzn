include "globals.mzn";

% Parameters
int: n = 5;
set of int: N = 1..n;

% Locations: 1=E, 2=F, 3=G, 4=H, 5=I
array[N, N] of int: cost =
[|  0, 65, 10, 25, 82
 | 65,  0, 98, 42, 26
 | 10, 98,  0, 75, 72
 | 25, 42, 75,  0, 46
 | 82, 26, 72, 46,  0
 |];

% Variables
array[N] of var N: succ;
var int: total_cost;

% Constraints
constraint forall(i in N)(succ[i] != i);
constraint circuit(succ);

constraint total_cost = sum(i in N)(cost[i, succ[i]]);

% Objective
solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];