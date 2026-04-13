include "globals.mzn";

int: n = 4;
set of int: CITIES = 1..n;

% Cost matrix (0 on diagonal; symmetric as given)
array[CITIES, CITIES] of int: cost =
  array2d(CITIES, CITIES,
  [  0, 27, 48, 76,
    27,  0, 82, 88,
    48, 82,  0, 97,
    76, 88, 97,  0 ]);

% tour[pos] = city visited at position pos
array[1..n] of var CITIES: tour;
constraint all_different(tour);

% Total travel cost (including return to start)
var int: total_cost =
  sum(i in 1..n-1)( cost[tour[i], tour[i+1]] ) + cost[tour[n], tour[1]];

solve minimize total_cost;

output [
  "Tour = ", show(tour), "\n",
  "Total cost = ", show(total_cost), "\n"
];