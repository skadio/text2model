% Parameters
% Cities are indexed 1..5 corresponding to [E,F,G,H,I]
int: nCities = 5;
set of int: CITIES = 1..nCities;

% Delivery cost matrix (cost[i,j] = cost from city i to city j)
array[CITIES, CITIES] of int: cost =
  [|  0, 31, 19, 71, 74   % From E
   | 31,  0, 39, 77, 84   % From F
   | 19, 39,  0, 65, 78   % From G
   | 71, 77, 65,  0, 38   % From H
   | 74, 84, 78, 38,  0   % From I
  |];

% Upper bound for tour cost (simple safe bound)
int: maxArcCost = max([cost[i,j] | i in CITIES, j in CITIES]);
int: maxTourCost = nCities * maxArcCost;

% Variables
% succ[i] = next city visited after city i (Hamiltonian cycle successor representation)
array[CITIES] of var CITIES: succ;

% Total delivery cost of the closed tour
var 0..maxTourCost: totalCost;

% Constraints
% (1) Enforce a single Hamiltonian cycle over all cities (no subtours)
constraint circuit(succ);

% (2) Define total tour cost as sum of costs on chosen successor arcs
constraint totalCost = sum(i in CITIES)(cost[i, succ[i]]);

% Objective
solve minimize totalCost;