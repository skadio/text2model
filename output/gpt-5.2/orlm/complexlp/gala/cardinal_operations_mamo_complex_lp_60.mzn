include "globals.mzn";

% Cities: 1=A, 2=B, 3=C, 4=D
int: n = 4;
set of int: Cities = 1..n;

% Travel cost matrix (0 on diagonal; symmetric as given)
array[Cities, Cities] of int: cost =
  [| 0, 19, 45, 30
   | 19, 0, 89, 46
   | 45, 89, 0, 11
   | 30, 46, 11, 0 |];

% Tour as a permutation of cities (visit each city exactly once)
array[1..n] of var Cities: tour;
constraint all_different(tour);

% Total cost includes returning to the starting city
var int: total_cost =
  sum(i in 1..n-1)( cost[tour[i], tour[i+1]] ) + cost[tour[n], tour[1]];

solve minimize total_cost;

output [
  "Tour (1=A,2=B,3=C,4=D) = ", show(tour), "\n",
  "Minimum total cost = ", show(total_cost), "\n"
];