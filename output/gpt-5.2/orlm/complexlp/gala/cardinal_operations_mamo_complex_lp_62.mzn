include "globals.mzn";

int: n = 4;
set of int: Cities = 1..n;

% Cost matrix (0 on diagonal; symmetric costs as given)
array[Cities, Cities] of int: cost =
  array2d(Cities, Cities,
    [  0, 52, 89, 11,
      52,  0, 14, 13,
      89, 14,  0, 87,
      11, 13, 87,  0
    ]);

% tour[k] = city visited in position k (a Hamiltonian cycle when closed)
array[1..n] of var Cities: tour;
constraint all_different(tour);

% Total travel cost including return from last to first
var int: total_cost =
  sum(k in 1..n-1)( cost[tour[k], tour[k+1]] ) + cost[tour[n], tour[1]];

solve minimize total_cost;

output [
  "Tour = ", show(tour), "\n",
  "Total cost = ", show(total_cost), "\n"
];