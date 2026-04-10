include "globals.mzn";

int: n = 5;
set of int: Cities = 1..n;

% Cost matrix (0 on diagonal, symmetric costs as given)
array[Cities, Cities] of int: cost =
[
|  0, 58, 15, 75, 91
| 58,  0, 54, 85, 11
| 15, 54,  0, 28, 61
| 75, 85, 28,  0, 47
| 91, 11, 61, 47,  0
];

% tour[k] is the city visited at position k in the cycle
array[Cities] of var Cities: tour;

constraint all_different(tour);

% Total travel cost including return to the first city
var int: total_cost =
  sum(k in 1..n-1)( cost[tour[k], tour[k+1]] )
  + cost[tour[n], tour[1]];

solve minimize total_cost;

output [
  "Tour = ", show(tour), "\n",
  "Minimum total travel cost = ", show(total_cost), "\n"
];