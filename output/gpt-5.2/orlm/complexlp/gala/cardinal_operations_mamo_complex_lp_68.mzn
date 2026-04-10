include "globals.mzn";

int: n = 5;
set of int: Cities = 1..n;

% Cost matrix (symmetric TSP). Use 0 on diagonal.
array[Cities, Cities] of int: cost =
  [|  0, 40, 40, 56, 93
   | 40,  0, 52, 71, 90
   | 40, 52,  0, 57, 14
   | 56, 71, 57,  0, 13
   | 93, 90, 14, 13,  0 |];

% tour[pos] = city visited at position pos (a permutation)
array[1..n] of var Cities: tour;
constraint all_different(tour);

% Symmetry breaking: fix a start city (cycle can start anywhere)
constraint tour[1] = 1;

% Total travel cost including return to start
var 0..100000: total_cost;
constraint total_cost =
  sum(i in 1..n-1)( cost[tour[i], tour[i+1]] ) + cost[tour[n], tour[1]];

solve minimize total_cost;

output [
  "Tour = ", show(tour), "\n",
  "TotalCost = ", show(total_cost), "\n"
];