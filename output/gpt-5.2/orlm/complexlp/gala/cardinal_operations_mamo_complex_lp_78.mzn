include "globals.mzn";

% Locations: 1=A, 2=B, 3=C, 4=D, 5=E, 6=F
int: n = 6;
set of int: LOC = 1..n;

% Delivery cost matrix (symmetric, 0 on diagonal)
array[LOC, LOC] of int: cost =
[
 |  0, 77, 89, 19, 31, 62
  | 77,  0, 36, 81, 71, 93
  | 89, 36,  0, 32, 48, 36
  | 19, 81, 32,  0, 98, 82
  | 31, 71, 48, 98,  0, 66
  | 62, 93, 36, 82, 66,  0
];

% tour[pos] is the location visited at position pos
array[1..n] of var LOC: tour;

% Visit each location exactly once
constraint all_different(tour);

% Total cost includes returning from last to first
var int: total_cost =
  sum(i in 1..n-1)( cost[tour[i], tour[i+1]] ) + cost[tour[n], tour[1]];

solve minimize total_cost;

output [
  "Minimum total delivery cost = ", show(total_cost), "\n",
  "Tour (1=A,2=B,3=C,4=D,5=E,6=F) = ", show(tour), "\n"
];