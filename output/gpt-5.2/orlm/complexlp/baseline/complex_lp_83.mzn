% Traveling Salesman Problem (TSP) for 5 shops, data embedded

int: n = 5;
set of int: SHOPS = 1..n;

array[SHOPS, SHOPS] of int: cost = array2d(SHOPS, SHOPS, [
  0, 13, 87, 76, 50,
  13, 0, 15, 65, 85,
  87, 15, 0, 45, 81,
  76, 65, 45, 0, 80,
  50, 85, 81, 80, 0
]);

% succ[i] is the next shop visited after i
array[SHOPS] of var SHOPS: succ;

% total tour cost
var int: total_cost = sum(i in SHOPS)(cost[i, succ[i]]);

constraint
  all_different(succ);         % each shop has a unique outgoing edge

constraint
  circuit(succ);               % single Hamiltonian cycle visiting all shops once

solve minimize total_cost;

output [
  "Optimal travel cost = ", show(total_cost), "\n",
  "Successor mapping (shop -> next shop): ", show(succ), "\n"
];