include "globals.mzn";

int: n = 5;
set of int: CITIES = 1..n;

/* Travel cost matrix (diagonal unused; set to 0) */
array[CITIES, CITIES] of int: cost =
  array2d(CITIES, CITIES,
  [  0, 28, 89, 59, 41,
    28,  0, 85, 12, 68,
    89, 85,  0, 22, 70,
    59, 12, 22,  0, 48,
    41, 68, 70, 48,  0 ]);

% tour[pos] = city visited at position pos
array[1..n] of var CITIES: tour;
constraint all_different(tour);

% Break rotational symmetry: fix a starting city
constraint tour[1] = 1;

var int: total_cost =
  sum(i in 1..n-1)( cost[tour[i], tour[i+1]] ) +
  cost[tour[n], tour[1]];

solve minimize total_cost;

output [
  "Tour = ", show(tour), "\n",
  "Total cost = ", show(total_cost), "\n"
];