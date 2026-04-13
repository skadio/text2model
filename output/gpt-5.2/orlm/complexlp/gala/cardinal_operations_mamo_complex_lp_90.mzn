include "globals.mzn";

% Cities: 1=E, 2=F, 3=G, 4=H, 5=I
int: n = 5;

% Cost matrix (symmetric, 0 on diagonal)
array[1..n, 1..n] of int: cost =
[
  %  E   F   G   H   I
  |  0, 64, 78, 23, 15  % E
  | 64,  0, 15, 44, 93  % F
  | 78, 15,  0, 53, 57  % G
  | 23, 44, 53,  0, 56  % H
  | 15, 93, 57, 56,  0  % I
];

% tour[pos] = city visited at position pos
array[1..n] of var 1..n: tour;

% Break rotational symmetry: fix start city to E
constraint tour[1] = 1;

% Visit each city exactly once
constraint all_different(tour);

% Total cost including return to start
var int: total_cost =
  sum(i in 1..n-1)( cost[tour[i], tour[i+1]] )
  + cost[tour[n], tour[1]];

solve minimize total_cost;

output [
  "Tour (1=E,2=F,3=G,4=H,5=I) = ", show(tour), "\n",
  "Minimum total cost = ", show(total_cost), "\n"
];