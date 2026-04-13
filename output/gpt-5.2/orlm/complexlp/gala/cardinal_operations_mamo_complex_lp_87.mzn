include "globals.mzn";

int: n = 5;
set of int: Cities = 1..n;

/* Travel cost matrix (diagonal unused/0) */
array[Cities, Cities] of int: cost =
  array2d(Cities, Cities, [
     0, 46, 63, 54, 45,
    46,  0, 48, 50, 51,
    63, 48,  0, 31, 64,
    54, 50, 31,  0, 94,
    45, 51, 64, 94,  0
  ]);

/* tour[k] = city visited in position k */
array[1..n] of var Cities: tour;
constraint all_different(tour);

/* Total cost of the Hamiltonian cycle (including return to start) */
var int: total_cost =
  sum(k in 1..n-1)( cost[tour[k], tour[k+1]] )
  + cost[tour[n], tour[1]];

/* Break rotational symmetry: fix the first visited city */
constraint tour[1] = 1;

solve minimize total_cost;

output [
  "Tour = ", show(tour), "\n",
  "Total cost = ", show(total_cost), "\n"
];