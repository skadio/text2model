% Traveling Salesman Problem (6 cities) - data embedded

int: n = 6;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
[
|  0, 43, 39, 97, 84, 67
| 43,  0, 18, 92, 27, 51
| 39, 18,  0, 84, 60, 15
| 97, 92, 84,  0, 42, 32
| 84, 27, 60, 42,  0, 18
| 67, 51, 15, 32, 18,  0
];

% successor representation: succ[i] is the next city visited after i
array[CITIES] of var CITIES: succ;

% ensure a single Hamiltonian cycle visiting each city exactly once
constraint circuit(succ);

var int: total_cost = sum(i in CITIES)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "Minimum total delivery cost = ", show(total_cost), "\n",
  "Successor mapping succ[i]=next_city: ", show(succ), "\n"
];