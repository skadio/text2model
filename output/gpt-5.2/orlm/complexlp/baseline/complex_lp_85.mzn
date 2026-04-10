% Traveling Salesperson Problem (TSP) for 6 cities with embedded data

int: n = 6;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
[
  % to:  1   2   3   4   5   6
       [ 0, 63, 62, 49, 58, 38], % from 1
       [63,  0, 93, 21, 66, 42], % from 2
       [62, 93,  0, 26, 99, 96], % from 3
       [49, 21, 26,  0, 73, 80], % from 4
       [58, 66, 99, 73,  0, 76], % from 5
       [38, 42, 96, 80, 76,  0]  % from 6
];

% succ[i] = next city visited after i
array[CITIES] of var CITIES: succ;

constraint
  forall(i in CITIES)(succ[i] != i) /\
  circuit(succ);

var int: total_cost = sum(i in CITIES)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "Minimum total travel cost = ", show(total_cost), "\n",
  "Successor mapping (city -> next):\n",
  concat([ show(i) ++ " -> " ++ show(succ[i]) ++ "\n" | i in CITIES ])
];