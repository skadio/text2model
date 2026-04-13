include "globals.mzn";

int: n = 6;
set of int: Cities = 1..n;

% Cost matrix (symmetric, with 0 on diagonal)
array[Cities, Cities] of int: cost =
[
|  0, 86, 81, 64, 65, 24 |
| 86,  0, 44, 80, 91, 23 |
| 81, 44,  0, 15, 25, 89 |
| 64, 80, 15,  0, 89, 41 |
| 65, 91, 25, 89,  0, 29 |
| 24, 23, 89, 41, 29,  0 |
];

% tour[pos] = city visited at position pos
array[1..n] of var Cities: tour;

% Symmetry breaking: fix start city to 1 (cycle is rotation-invariant)
constraint tour[1] = 1;

% Visit each city exactly once
constraint all_different(tour);

% Total cost of completing the cycle
var int: total_cost =
    sum(pos in 1..n-1)( cost[tour[pos], tour[pos+1]] )
  + cost[tour[n], tour[1]];

solve minimize total_cost;

output [
  "Tour = ", show(tour), "\n",
  "Minimum total cost = ", show(total_cost), "\n"
];