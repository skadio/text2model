include "globals.mzn";

int: n = 4;
set of int: CITIES = 1..n;

% Travel cost matrix (cost[i,j] = cost to go from city i to city j)
array[CITIES, CITIES] of int: cost =
  array2d(CITIES, CITIES,
  [  0, 61, 17, 81,
    61,  0, 40, 52,
    17, 40,  0, 23,
    81, 52, 23,  0 ]);

% tour[k] is the k-th visited city (a permutation)
array[1..n] of var CITIES: tour;
constraint all_different(tour);

% Total cost of the cycle (including return from last to first)
var int: total_cost =
  sum(k in 1..n-1)( cost[tour[k], tour[k+1]] ) + cost[tour[n], tour[1]];

% Break rotational symmetry: fix starting city to 1 (doesn't change optimal cost)
constraint tour[1] = 1;

solve minimize total_cost;

output [
  "Tour = ", show(tour), "\n",
  "Total cost = ", show(total_cost), "\n"
];