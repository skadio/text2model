% Traveling Salesperson Problem for 4 cities with embedded data

int: n = 4;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
  [| 0, 17, 25, 31
   | 17, 0, 93, 45
   | 25, 93, 0, 95
   | 31, 45, 95, 0 |];

% Fix start city to 1 (cycle is invariant under rotation)
int: start = 1;

array[1..n] of var CITIES: tour;
constraint tour[1] = start;
constraint all_different(tour);

% Return to start to form a cycle
var int: total_cost =
  sum(i in 1..n-1)( cost[tour[i], tour[i+1]] ) + cost[tour[n], tour[1]];

solve minimize total_cost;

output [
  "tour = ", show(tour), " (return to ", show(tour[1]), ")\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];