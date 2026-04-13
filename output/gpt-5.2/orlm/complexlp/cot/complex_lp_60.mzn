% Parameters (with values embedded)
int: n = 4;
set of int: Cities = 1..n; % 1=A, 2=B, 3=C, 4=D

array[Cities, Cities] of int: cost =
  [|  0, 19, 45, 30
   | 19,  0, 89, 46
   | 45, 89,  0, 11
   | 30, 46, 11,  0 |];

% Variables
array[Cities] of var Cities: succ; % successor city for each city (tour edges)
var int: total_cost;

% Constraints
constraint
  alldifferent(succ); % each city has a unique successor

constraint
  forall(i in Cities)(succ[i] != i); % no self-loops

% Ensure a single Hamiltonian cycle (no subtours)
include "globals.mzn";
constraint
  circuit(succ);

constraint
  total_cost = sum(i in Cities)(cost[i, succ[i]]);

% Objective
solve minimize total_cost;