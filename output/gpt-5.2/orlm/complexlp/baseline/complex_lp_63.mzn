int: n = 5;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
[
 |   0, 28, 89, 59, 41
  |  28,  0, 85, 12, 68
  |  89, 85,  0, 22, 70
  |  59, 12, 22,  0, 48
  |  41, 68, 70, 48,  0
];

% Successor representation of a Hamiltonian cycle
array[CITIES] of var CITIES: succ;

constraint
  forall(i in CITIES)(succ[i] != i);

% Ensure a single tour visiting all cities exactly once
constraint
  circuit(succ);

var int: total_cost = sum(i in CITIES)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "Minimum total travel cost = ", show(total_cost), "\n",
  "Successor mapping (i -> succ[i]):\n",
  concat([ show(i) ++ " -> " ++ show(succ[i]) ++ "\n" | i in CITIES ])
];