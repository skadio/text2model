include "globals.mzn";

% Parameters
int: n = 5;
set of int: N = 1..n; % 1=A, 2=B, 3=C, 4=D, 5=E

array[N, N] of int: cost =
  [| 0, 15, 88, 54, 92
   | 15, 0, 29, 98, 33
   | 88, 29, 0, 96, 96
   | 54, 98, 96, 0, 63
   | 92, 33, 96, 63, 0 |];

% Variables
array[N] of var N: succ;   % successor warehouse in the tour
var int: totalCost;

% Constraints: single Hamiltonian circuit
constraint circuit(succ);

% Total cost of the tour
constraint totalCost = sum(i in N)(cost[i, succ[i]]);

% Objective
solve minimize totalCost;

output [
  "totalCost = ", show(totalCost), "\n",
  "succ = ", show(succ), "\n"
];