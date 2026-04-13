include "globals.mzn";

int: n = 6;
set of int: Cities = 1..n;

/% Cost matrix: cost[i,j] is travel cost from city i to city j (i != j) %/
array[Cities, Cities] of int: cost =
  [|  0, 65, 41, 14, 16, 35
   | 65,  0, 76, 52, 89, 45
   | 41, 76,  0, 72, 38, 62
   | 14, 52, 72,  0, 22, 24
   | 16, 89, 38, 22,  0, 89
   | 35, 45, 62, 24, 89,  0 |];

% tour[k] = city visited in position k
array[1..n] of var Cities: tour;
constraint all_different(tour);

% Break rotational symmetry: fix starting city to 1 (doesn't change optimal cost)
constraint tour[1] = 1;

var int: total_cost =
  sum(k in 1..n-1)( cost[tour[k], tour[k+1]] ) + cost[tour[n], tour[1]];

solve minimize total_cost;

output [
  "Tour = ", show(tour), "\n",
  "Minimum total travel cost = ", show(total_cost), "\n"
];