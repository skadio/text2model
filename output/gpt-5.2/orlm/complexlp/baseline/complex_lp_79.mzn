% Traveling Salesperson Problem (5 cities) with embedded data

int: n = 5;
set of int: CITIES = 1..n;
array[CITIES] of string: name = ["A","B","C","D","E"];

% Cost matrix (diagonal set to 0; symmetric as given)
array[CITIES, CITIES] of int: cost =
[
|  0, 44, 19, 92, 71
| 44,  0, 22, 84, 63
| 19, 22,  0, 47, 89
| 92, 84, 47,  0, 78
| 71, 63, 89, 78,  0
];

% Successor representation: succ[i] is the next city after i
array[CITIES] of var CITIES: succ;

% Ensure a single Hamiltonian cycle visiting all cities exactly once
constraint circuit(succ);

var int: total_cost = sum(i in CITIES)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "Minimum total travel cost = ", show(total_cost), "\n",
  "Successor mapping (city -> next):\n"
] ++
[
  name[i] ++ " -> " ++ name[fix(succ[i])] ++ "\n"
  | i in CITIES
];