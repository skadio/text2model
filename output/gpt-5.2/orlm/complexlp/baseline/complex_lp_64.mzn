% Traveling Salesperson Problem with 6 cities (symmetric costs)
% Visit each city exactly once and return to start; minimize total cost.

int: n = 6;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
[
  %  1   2   3   4   5   6
  [  0, 65, 41, 14, 16, 35], % from 1
  [ 65,  0, 76, 52, 89, 45], % from 2
  [ 41, 76,  0, 72, 38, 62], % from 3
  [ 14, 52, 72,  0, 22, 24], % from 4
  [ 16, 89, 38, 22,  0, 89], % from 5
  [ 35, 45, 62, 24, 89,  0]  % from 6
];

% succ[i] is the next city visited after i
array[CITIES] of var CITIES: succ;

constraint
  forall(i in CITIES) (succ[i] != i);     % no self-loop
constraint
  circuit(succ);                          % single Hamiltonian cycle

var int: total_cost =
  sum(i in CITIES)( cost[i, succ[i]] );

solve minimize total_cost;

output [
  "Minimum total travel cost = ", show(total_cost), "\n",
  "Successor mapping (city -> next city):\n",
  concat([ show(i) ++ " -> " ++ show(succ[i]) ++ "\n" | i in CITIES ])
];