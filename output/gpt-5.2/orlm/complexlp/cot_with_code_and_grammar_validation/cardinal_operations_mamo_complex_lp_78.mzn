include "globals.mzn";

% Parameters
int: n = 6;
set of int: LOC = 1..n; % 1=A, 2=B, 3=C, 4=D, 5=E, 6=F

array[LOC, LOC] of int: cost =
  [|   0, 77, 89, 19, 31, 62
   |  77,  0, 36, 81, 71, 93
   |  89, 36,  0, 32, 48, 36
   |  19, 81, 32,  0, 98, 82
   |  31, 71, 48, 98,  0, 66
   |  62, 93, 36, 82, 66,  0
  |];

% Variables
array[LOC] of var LOC: next;        % successor of each location in the tour
var int: total_cost;

% Constraints: single Hamiltonian cycle
constraint circuit(next);

% Objective
constraint total_cost = sum(i in LOC)(cost[i, next[i]]);
solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "next = ", show(next), "\n"
];