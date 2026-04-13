include "globals.mzn";

int: n = 4;
set of int: CITIES = 1..n;

% Travel costs (directed; here symmetric as given)
array[CITIES, CITIES] of int: cost =
  array2d(CITIES, CITIES, [
    0, 94, 34, 87,
    94, 0, 62, 87,
    34, 62, 0, 97,
    87, 87, 97, 0
  ]);

% next_city[i] = city visited immediately after city i
array[CITIES] of var CITIES: next_city;

% Ensure every city has exactly one successor and (with circuit) one predecessor,
% forming a single Hamiltonian cycle.
constraint circuit(next_city);

var int: total_cost = sum(i in CITIES)( cost[i, next_city[i]] );

solve minimize total_cost;

output [
  "Minimum total cost = ", show(total_cost), "\n",
  "Tour (successor representation) next_city = ", show(next_city), "\n"
];