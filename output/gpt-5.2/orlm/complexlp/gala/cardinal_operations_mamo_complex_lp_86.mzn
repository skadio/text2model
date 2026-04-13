include "globals.mzn";

int: n = 5;
set of int: Cities = 1..n;

/* Travel cost matrix (cost[i,j] = cost to go from city i to city j) */
array[Cities, Cities] of int: cost =
  [|  0, 73, 39, 79, 38
   | 73,  0, 30, 46, 29
   | 39, 30,  0, 88, 57
   | 79, 46, 88,  0, 59
   | 38, 29, 57, 59,  0 |];

/* tour[pos] is the city visited at position pos in the cycle */
array[Cities] of var Cities: tour;

/* Fix the starting city to 1 to remove rotational symmetry */
constraint tour[1] = 1;

/* Visit each city exactly once */
constraint all_different(tour);

/* Total cost: sum of edges along the tour, including return to start */
var int: total_cost =
  sum(i in 1..n-1)( cost[tour[i], tour[i+1]] )
  + cost[tour[n], tour[1]];

solve minimize total_cost;

output [
  "Tour = ", show(tour), "\n",
  "Minimum total travel cost = ", show(total_cost), "\n"
];