% Traveling Salesman Problem (4 locations), data embedded

int: n = 4;
set of int: N = 1..n;

% Map: 1=E, 2=F, 3=G, 4=H
array[N,N] of int: cost = array2d(N,N,[
  0, 62, 51, 50,   % from E
  62, 0, 42, 69,   % from F
  51, 42, 0, 11,   % from G
  50, 69, 11, 0    % from H
]);

array[N] of var N: succ;  % successor city for each city

constraint
  forall(i in N)(succ[i] != i);                 % no self-loop
constraint
  forall(j in N)(count(i in N)(succ[i] = j) = 1); % each city has exactly one predecessor

% Single Hamiltonian cycle (no subtours)
include "globals.mzn";
constraint circuit(succ);

var int: total_cost = sum(i in N)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "Minimum total delivery cost = ", show(total_cost), "\n",
  "Successor mapping (1=E,2=F,3=G,4=H):\n",
  concat([ show(i) ++ " -> " ++ show(succ[i]) ++ "\n" | i in N ])
];