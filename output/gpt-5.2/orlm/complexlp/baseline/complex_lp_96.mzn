% Traveling Salesperson Problem (6 cities), data embedded

int: n = 6;
set of int: Cities = 1..n;

array[Cities, Cities] of int: cost =
[
  %  1   2   3   4   5    6
  |  0, 21, 43, 25, 38,  91   % from 1
  | 21,  0, 32, 25, 16,  14   % from 2
  | 43, 32,  0, 96, 71,  98   % from 3
  | 25, 25, 96,  0, 53,  22   % from 4
  | 38, 16, 71, 53,  0, 100   % from 5
  | 91, 14, 98, 22,100,   0   % from 6
];

% successor representation: succ[i] is the city visited after i
array[Cities] of var Cities: succ;

% Enforce a single Hamiltonian cycle through all cities
constraint circuit(succ);

var int: total_cost =
  sum(i in Cities)( cost[i, succ[i]] );

solve minimize total_cost;

output [
  "Minimum total travel cost = ", show(total_cost), "\n",
  "Successor mapping (i -> succ[i]):\n",
  concat([ show(i) ++ " -> " ++ show(succ[i]) ++ "\n" | i in Cities ])
];