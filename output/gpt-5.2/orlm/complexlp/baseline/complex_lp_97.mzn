% Travelling Salesman Problem (4 cities) with embedded data

int: n = 4;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
  [|  0, 76, 17, 24
   | 76,  0, 84, 11
   | 17, 84,  0, 90
   | 24, 11, 90,  0 |];

% Fix starting city to 1 (any optimal tour can be rotated to start at 1)
array[1..n] of var CITIES: tour;
constraint tour[1] = 1;
constraint all_different(tour);

var int: total_cost =
  sum(i in 1..n-1)(cost[tour[i], tour[i+1]]) + cost[tour[n], tour[1]];

solve minimize total_cost;

output [
  "Minimum total travel cost = ", show(total_cost), "\n",
  "Tour (starting at City 1) = ", show(tour), " -> 1\n"
];