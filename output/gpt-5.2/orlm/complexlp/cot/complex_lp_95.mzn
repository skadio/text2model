% Parameters (with values embedded)
int: n = 4;
set of int: LOC = 1..n; % 1=E, 2=F, 3=G, 4=H

array[LOC, LOC] of int: cost =
%     E   F   G   H
  [|  0, 62, 51, 50   % E
   | 62,  0, 42, 69   % F
   | 51, 42,  0, 11   % G
   | 50, 69, 11,  0   % H
  |];

% Variables
array[LOC] of var LOC: succ;  % successor city in the tour

% Constraints
constraint circuit(succ);     % single Hamiltonian cycle visiting each location exactly once

% Objective
var int: total_cost = sum(i in LOC)(cost[i, succ[i]]);
solve minimize total_cost;

output [
  "Minimum total delivery cost = ", show(total_cost), "\n",
  "Successor mapping (1=E,2=F,3=G,4=H): ", show(succ), "\n"
];