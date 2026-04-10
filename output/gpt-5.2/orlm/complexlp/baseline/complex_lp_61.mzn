% Traveling Salesperson Problem for 4 cities: E, F, G, H
include "globals.mzn";

enum City = {E, F, G, H};
int: n = card(City);
set of int: N = 1..n;

array[N] of City: city_of = [E, F, G, H];

% Cost matrix (symmetric), with a large value on the diagonal to forbid self-loops.
int: INF = 10_000;
array[N, N] of int: cost = array2d(N, N, [
  INF, 17, 52, 79,
   17, INF, 15, 71,
   52, 15, INF, 54,
   79, 71, 54, INF
]);

% successor representation of a Hamiltonian cycle
array[N] of var N: succ;

constraint
  forall(i in N)(succ[i] != i);

constraint
  circuit(succ);

var int: total_cost =
  sum(i in N)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "Minimum total travel cost = ", show(total_cost), "\n",
  "Tour (city -> next):\n"
] ++
[
  show(city_of[i]) ++ " -> " ++ show(city_of[fix(succ[i])]) ++ "\n"
  | i in N
];