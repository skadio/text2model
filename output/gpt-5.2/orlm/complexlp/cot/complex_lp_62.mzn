% Parameters (with values embedded)
int: N = 4;
set of int: Cities = 1..N;

array[Cities, Cities] of int: cost =
  [|  0, 52, 89, 11
   | 52,  0, 14, 13
   | 89, 14,  0, 87
   | 11, 13, 87,  0 |];

% Variables
array[Cities] of var Cities: succ; % successor city for each city in the tour
var 0..sum(i in Cities, j in Cities)(cost[i,j]): total_cost;

% Constraints
constraint forall(i in Cities)(succ[i] != i);      % no self-loops
constraint circuit(succ);                          % single Hamiltonian cycle

constraint total_cost = sum(i in Cities)(cost[i, succ[i]]);

% Objective
solve minimize total_cost;