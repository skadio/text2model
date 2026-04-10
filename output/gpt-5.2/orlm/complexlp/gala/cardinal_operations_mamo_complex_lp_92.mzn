include "globals.mzn";

int: n = 6;
set of int: Cities = 1..n;

/% Cost matrix (symmetric TSP), with 0 on diagonal %/
array[Cities, Cities] of int: cost =
[
|  0, 43, 39, 97, 84, 67
| 43,  0, 18, 92, 27, 51
| 39, 18,  0, 84, 60, 15
| 97, 92, 84,  0, 42, 32
| 84, 27, 60, 42,  0, 18
| 67, 51, 15, 32, 18,  0
];

/% tour[p] = city visited at position p %/
array[1..n] of var Cities: tour;
constraint all_different(tour);

/% Break rotational symmetry: fix starting city to 1 %/
constraint tour[1] = 1;

/% Total tour cost including return to start %/
var int: total_cost =
  sum(p in 1..n-1)( cost[tour[p], tour[p+1]] ) + cost[tour[n], tour[1]];

solve minimize total_cost;

output [
  "Tour = ", show(tour), "\n",
  "Total cost = ", show(total_cost), "\n"
];