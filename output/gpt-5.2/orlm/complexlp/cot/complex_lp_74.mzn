% Parameters (with values embedded)
int: N = 4;
set of int: Cities = 1..N;

array[Cities, Cities] of int: cost =
 [| 0, 29, 97, 72
  | 29, 0, 69, 52
  | 97, 69, 0, 91
  | 72, 52, 91, 0 |];

% Variables
array[Cities] of var Cities: succ;  % successor city in the tour for each city
var int: total_cost;

% Constraints
constraint circuit(succ); % single Hamiltonian cycle visiting each city exactly once

constraint total_cost = sum(i in Cities)(cost[i, succ[i]]);

% Objective
solve minimize total_cost;