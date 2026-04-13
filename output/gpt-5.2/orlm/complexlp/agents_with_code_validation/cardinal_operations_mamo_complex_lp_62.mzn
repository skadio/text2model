include "globals.mzn";

% Parameters
int: nCities = 4;
set of int: CITIES = 1..nCities;

% Travel cost matrix (cost[i,j] = cost to go from city i to city j)
array[CITIES, CITIES] of int: cost =
  [|  0, 52, 89, 11
   | 52,  0, 14, 13
   | 89, 14,  0, 87
   | 11, 13, 87,  0 |];

% Upper bound on total tour cost
int: maxArcCost = max([ cost[i,j] | i in CITIES, j in CITIES ]);
int: maxTotalCost = nCities * maxArcCost;

% Decision variables
array[CITIES] of var CITIES: succ;   % succ[i] = next city after i
var 0..maxTotalCost: total_cost;

% Constraints: single Hamiltonian cycle
constraint circuit(succ);

% Objective: minimize total travel cost
constraint total_cost = sum(i in CITIES)(cost[i, succ[i]]);

solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "succ = ", show(succ), "\n"
];