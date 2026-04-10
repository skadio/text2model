include "globals.mzn";

int: n = 6;
set of int: Cities = 1..n;

% Cost matrix (symmetric), with 0 on the diagonal
array[Cities, Cities] of int: cost =
  [|  0, 23, 50, 92, 56, 91
   | 23,  0, 38, 25, 25, 69
   | 50, 38,  0, 66, 51, 76
   | 92, 25, 66,  0, 97, 37
   | 56, 25, 51, 97,  0, 30
   | 91, 69, 76, 37, 30,  0 |];

% tour[pos] = city visited at position pos
array[1..n] of var Cities: tour;

% Break rotational symmetry: start at city 1
constraint tour[1] = 1;

% Visit each city exactly once
constraint all_different(tour);

% Total travel cost, including return to start
var int: total_cost =
  sum(i in 1..n-1)( cost[tour[i], tour[i+1]] ) + cost[tour[n], tour[1]];

solve minimize total_cost;

output [
  "Tour = ", show(tour), "\n",
  "Total cost = ", show(total_cost), "\n"
];