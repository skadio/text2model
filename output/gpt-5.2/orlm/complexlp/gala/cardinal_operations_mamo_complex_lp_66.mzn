include "globals.mzn";

int: n = 6;
set of int: LOC = 1..n;

% Cost matrix (0 on diagonal; symmetric costs as given)
array[LOC, LOC] of int: cost =
[|  0, 48, 23, 70, 14, 20
 | 48,  0, 79, 37, 63, 96
 | 23, 79,  0, 40, 66, 68
 | 70, 37, 40,  0, 70, 28
 | 14, 63, 66, 70,  0, 73
 | 20, 96, 68, 28, 73,  0 |];

% succ[i] = next location visited after i
array[LOC] of var LOC: succ;

% Ensure a Hamiltonian cycle (single tour visiting all nodes once)
constraint all_different(succ);
constraint forall(i in LOC)(succ[i] != i);   % forbid self-loops
constraint circuit(succ);

var int: total_cost = sum(i in LOC)( cost[i, succ[i]] );

solve minimize total_cost;

output [
  "Minimum total delivery cost = ", show(total_cost), "\n",
  "Successor representation succ = ", show(succ), "\n"
];