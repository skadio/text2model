include "globals.mzn";

int: n = 4;
set of int: CITIES = 1..n;

% Travel cost matrix (cost[i,j] = cost from city i to city j)
array[CITIES, CITIES] of int: cost =
  [|  0, 17, 25, 31
   | 17,  0, 93, 45
   | 25, 93,  0, 95
   | 31, 45, 95,  0 |];

% tour[pos] = city visited at position pos (a permutation of 1..4)
array[1..n] of var CITIES: tour;
constraint all_different(tour);

% Total cost of the cycle: tour[1] -> ... -> tour[n] -> tour[1]
var int: total_cost =
  sum(p in 1..n-1)( cost[tour[p], tour[p+1]] ) + cost[tour[n], tour[1]];

solve minimize total_cost;

output [
  "Tour = ", show(tour), "\n",
  "TotalCost = ", show(total_cost), "\n"
];