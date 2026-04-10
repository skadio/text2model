% Traveling Salesperson Problem (5 cities) with embedded data

int: n = 5;
set of int: Cities = 1..n;

array[Cities, Cities] of int: cost =
  [| 0, 87, 41, 55, 57
   | 87, 0, 80, 33, 40
   | 41, 80, 0, 90, 42
   | 55, 33, 90, 0, 53
   | 57, 40, 42, 53, 0 |];

% succ[i] is the next city visited after i (a Hamiltonian cycle)
array[Cities] of var Cities: succ;

constraint
  forall(i in Cities)(succ[i] != i);          % no self-loop
constraint
  alldifferent(succ);                         % permutation -> each city has exactly one outgoing and one incoming
constraint
  circuit(succ);                              % single tour visiting all cities exactly once

var int: total_cost = sum(i in Cities)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "Minimum total travel cost = ", show(total_cost), "\n",
  "Successor mapping (city -> next city):\n",
  concat([ show(i) ++ " -> " ++ show(succ[i]) ++ "\n" | i in Cities ])
];