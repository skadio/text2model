include "globals.mzn";

% Cities: 1=E, 2=F, 3=G, 4=H, 5=I
int: n = 5;
set of int: CITIES = 1..n;

% Symmetric delivery cost matrix (0 on diagonal)
array[CITIES, CITIES] of int: cost =
  [|  0, 31, 19, 71, 74
   | 31,  0, 39, 77, 84
   | 19, 39,  0, 65, 78
   | 71, 77, 65,  0, 38
   | 74, 84, 78, 38,  0 |];

% route[t] is the city visited at position t in the tour
array[1..n] of var CITIES: route;
constraint all_different(route);

% Total tour cost including return to start
var int: totalCost =
  sum(t in 1..n-1)( cost[route[t], route[t+1]] )
  + cost[route[n], route[1]];

solve minimize totalCost;

output [
  "Route (1=E,2=F,3=G,4=H,5=I) = ", show(route), "\n",
  "Minimum total delivery cost = ", show(totalCost), "\n"
];