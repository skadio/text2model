include "globals.mzn";

% Parameters
int: n = 5;
set of int: CITIES = 1..n;

% City mapping: 1=A, 2=B, 3=C, 4=D, 5=E
array[CITIES, CITIES] of int: cost =
[|   0,  95,  36,  93,  16
 |  95,   0,  95,  29,  96
 |  36,  95,   0,  72,  38
 |  93,  29,  72,   0,  77
 |  16,  96,  38,  77,   0 |];

int: max_cost = max([cost[i,j] | i in CITIES, j in CITIES]);
int: UB = n * max_cost;

% Variables
array[1..n] of var CITIES: tour;          % permutation of cities (order visited)
var 0..UB: total_cost;

% Constraints
constraint all_different(tour);

constraint total_cost =
  sum(k in 1..n-1)(cost[tour[k], tour[k+1]]) + cost[tour[n], tour[1]];

% Objective
solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "tour=", show(tour), "\n"
];