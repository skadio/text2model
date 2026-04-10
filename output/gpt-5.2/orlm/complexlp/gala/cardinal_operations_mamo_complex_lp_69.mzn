include "globals.mzn";

% Traveling Salesperson Problem (6 cities), minimize total tour cost (return to start)

int: n = 6;
set of int: CITIES = 1..n;

% Cost matrix (given in the problem statement)
% NOTE: Costs on the diagonal are not used (no travel from a city to itself).
array[CITIES, CITIES] of int: cost =
[
  % to:   1   2   3   4   5   6
  |   0, 83, 30, 38, 74, 52   % from 1
  |  65,  0, 93, 13, 59, 47   % from 2
  |  44, 58,  0, 85, 17, 68   % from 3
  |  29, 71, 40,  0, 62, 33   % from 4
  |  87, 42, 55, 69,  0, 26   % from 5
  |  36, 80, 61, 24, 57,  0   % from 6
];

% Decision variables: tour is a permutation of cities (visit order)
array[1..n] of var CITIES: tour;
constraint all_different(tour);

% Total cost of the circuit, including return from last city to first
var int: total_cost =
  sum(i in 1..n-1)( cost[tour[i], tour[i+1]] ) + cost[tour[n], tour[1]];

solve minimize total_cost;

output [
  "Tour (visit order) = ", show(tour), "\n",
  "Minimum total travel cost = ", show(total_cost), "\n"
];