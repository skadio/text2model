% Traveling Salesman Problem (5 cities) with embedded data

int: n = 5;
set of int: CITIES = 1..n;

% Cost matrix (symmetric, diagonal unused -> 0)
array[CITIES, CITIES] of int: cost =
[|  0, 35, 90, 23, 62
 | 35,  0, 53, 58, 46
 | 90, 53,  0, 28, 91
 | 23, 58, 28,  0, 77
 | 62, 46, 91, 77,  0
 |];

% Fix start city to 1 (E) without loss of optimality for a cycle
% (Any Hamiltonian cycle can be rotated to start at any city with same cost.)
array[1..n] of var CITIES: tour;
constraint tour[1] = 1;
constraint all_different(tour);

var int: total_cost =
    sum(i in 1..n-1)( cost[tour[i], tour[i+1]] )
  + cost[tour[n], tour[1]];

solve minimize total_cost;

output [
  "Minimum total travel cost = ", show(total_cost), "\n",
  "Tour (1=E,2=F,3=G,4=H,5=I): ", show(tour), " -> ", show(tour[1]), "\n"
];