include "globals.mzn";

int: n = 4;
set of int: CITIES = 1..n;

% Travel cost matrix (symmetric; diagonal unused)
array[CITIES, CITIES] of int: cost =
  [| 0, 26, 49, 75
   | 26, 0, 19, 52
   | 49, 19, 0, 49
   | 75, 52, 49, 0 |];

% Visit each city exactly once (a tour order)
array[1..n] of var CITIES: city_order;
constraint all_different(city_order);

% Total tour cost (including return to start)
var int: total_cost =
  sum(i in 1..n-1)( cost[city_order[i], city_order[i+1]] )
  + cost[city_order[n], city_order[1]];

solve minimize total_cost;

output [
  "Tour order = ", show(city_order), "\n",
  "Total cost = ", show(total_cost), "\n"
];