include "globals.mzn";

int: n = 5;
set of int: CITIES = 1..n;

% Cost matrix (diagonal entries unused; set to 0)
array[CITIES, CITIES] of int: cost =
  array2d(CITIES, CITIES,
  [ 0, 87, 41, 55, 57,
    87, 0, 80, 33, 40,
    41, 80, 0, 90, 42,
    55, 33, 90, 0, 53,
    57, 40, 42, 53, 0 ]);

% tour[pos] = city visited at position pos
array[CITIES] of var CITIES: tour;
constraint all_different(tour);

% Total cost of the Hamiltonian cycle defined by tour
var int: total_cost =
  sum(i in 1..n-1)( cost[tour[i], tour[i+1]] ) + cost[tour[n], tour[1]];

solve minimize total_cost;

output [
  "Tour = ", show(tour), "\n",
  "Total cost = ", show(total_cost), "\n"
];