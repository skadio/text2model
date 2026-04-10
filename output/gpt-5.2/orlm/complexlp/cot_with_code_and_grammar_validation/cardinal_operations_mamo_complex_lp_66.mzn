include "globals.mzn";

% Parameters
int: n = 6;
set of int: N = 1..n;

array[N, N] of int: cost =
  [|   0,  48,  23,  70,  14,  20
   |  48,   0,  79,  37,  63,  96
   |  23,  79,   0,  40,  66,  68
   |  70,  37,  40,   0,  70,  28
   |  14,  63,  66,  70,   0,  73
   |  20,  96,  68,  28,  73,   0
   |];

% Variables
array[N] of var N: succ;        % successor location for each location
array[N] of var N: pred;        % predecessor location for each location
var int: total_cost;

% Constraints: single Hamiltonian cycle
constraint forall(i in N) (succ[i] != i);
constraint forall(i in N) (pred[i] != i);

constraint all_different(succ);
constraint all_different(pred);
constraint inverse(succ, pred);

% Total cost
constraint total_cost = sum(i in N)(cost[i, succ[i]]);

% Objective
solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];