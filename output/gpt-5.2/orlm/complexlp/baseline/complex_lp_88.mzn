% Traveling Salesperson Problem (5 locations: E,F,G,H,I)
% Find a minimum-cost Hamiltonian cycle (start anywhere).

include "globals.mzn";

int: n = 5;
set of int: N = 1..n;

array[N] of string: name = ["E","F","G","H","I"];

% Cost matrix (diagonal set to 0; not used by circuit constraint)
array[N,N] of int: cost = array2d(N,N,[
  0,  65, 10, 25, 82,   % E -> E,F,G,H,I
  65, 0,  98, 42, 26,   % F -> E,F,G,H,I
  10, 98, 0,  75, 72,   % G -> E,F,G,H,I
  25, 42, 75, 0,  46,   % H -> E,F,G,H,I
  82, 26, 72, 46, 0     % I -> E,F,G,H,I
]);

array[N] of var N: succ;

constraint circuit(succ);

var int: total_cost = sum(i in N)( cost[i, succ[i]] );

solve minimize total_cost;

output [
  "Minimum total delivery cost = ", show(total_cost), "\n",
  "Successor mapping:\n"
] ++
[
  name[i] ++ " -> " ++ name[fix(succ[i])] ++ "\n" | i in N
];