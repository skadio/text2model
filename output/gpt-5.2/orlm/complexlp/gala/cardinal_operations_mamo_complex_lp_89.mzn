include "globals.mzn";

int: n = 5;
set of int: Cities = 1..n;

% Travel cost matrix (0 on diagonal)
array[Cities, Cities] of int: cost =
  [|  0, 82, 76, 92, 59
   | 82,  0, 98, 58, 82
   | 76, 98,  0, 26, 74
   | 92, 58, 26,  0, 96
   | 59, 82, 74, 96,  0 |];

% tour[pos] = city visited at position pos
array[Cities] of var Cities: tour;
constraint all_different(tour);

% Break rotational symmetry: fix starting city
constraint tour[1] = 1;

% Total cost including return to start
var int: total_cost =
  sum(p in 1..n-1)( cost[tour[p], tour[p+1]] ) + cost[tour[n], tour[1]];

solve minimize total_cost;

output [
  "Tour = ", show(tour), "\n",
  "Total cost = ", show(total_cost), "\n"
];