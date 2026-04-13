include "globals.mzn";

int: n = 4;
set of int: Cities = 1..n;

% Travel cost matrix (symmetric TSP; diagonal set to 0)
array[Cities, Cities] of int: cost =
  [| 0, 29, 97, 72
   | 29, 0, 69, 52
   | 97, 69, 0, 91
   | 72, 52, 91, 0 |];

% city_order is the visiting sequence (a Hamiltonian cycle when we return to start)
array[Cities] of var Cities: city_order;

% Symmetry breaking: fix start city to 1 (cycle can start anywhere otherwise)
constraint city_order[1] = 1;

% Visit each city exactly once
constraint all_different(city_order);

% Total tour cost (including return to the starting city)
var int: total_cost =
  sum(i in 1..n-1)( cost[city_order[i], city_order[i+1]] )
  + cost[city_order[n], city_order[1]];

solve minimize total_cost;

output [
  "Tour order = ", show(city_order), "\n",
  "Minimum total cost = ", show(total_cost), "\n"
];