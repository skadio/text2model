% Traveling Salesperson Problem (5 cities) with embedded data

int: n = 5;
set of int: CITIES = 1..n;

array[CITIES, CITIES] of int: cost =
[
  % 1   2   3   4   5
  [ 0, 58, 15, 75, 91], % from 1
  [58,  0, 54, 85, 11], % from 2
  [15, 54,  0, 28, 61], % from 3
  [75, 85, 28,  0, 47], % from 4
  [91, 11, 61, 47,  0]  % from 5
];

% Successor representation: succ[i] = next city after i in the tour
array[CITIES] of var CITIES: succ;

% One Hamiltonian cycle
constraint all_different(succ);
include "globals.mzn";
constraint circuit(succ);

var int: total_cost = sum(i in CITIES)( cost[i, succ[i]] );

solve minimize total_cost;

output [
  "Minimum total travel cost = ", show(total_cost), "\n",
  "Successor array (city -> next): ", show(succ), "\n"
];