include "globals.mzn";

int: n = 6;
set of int: CITIES = 1..n;

% Cost matrix (diagonal set to 0; it will never be used due to all_different successor)
array[CITIES, CITIES] of int: cost =
[| 0, 49, 34, 18, 62, 14
 | 49, 0, 35, 24, 57, 17
 | 34, 35, 0, 20, 34, 58
 | 18, 24, 20, 0, 47, 45
 | 62, 57, 34, 47, 0, 71
 | 14, 17, 58, 45, 71, 0 |];

% tour[i] = successor city visited after city i
array[CITIES] of var CITIES: tour;

% No city can go to itself, and each city has a distinct successor (a permutation)
constraint forall(i in CITIES)(tour[i] != i);
constraint all_different(tour);

% Eliminate subtours: ensure a single Hamiltonian cycle
constraint circuit(tour);

var int: total_cost = sum(i in CITIES)( cost[i, tour[i]] );

solve minimize total_cost;

output [
  "Minimum total travel cost = ", show(total_cost), "\n",
  "Successor tour (city -> next city) = ", show(tour), "\n"
];