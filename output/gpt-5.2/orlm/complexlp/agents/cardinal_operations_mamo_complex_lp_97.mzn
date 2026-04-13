% Parameters
int: n = 4;                              % Number of cities
set of int: CITIES = 1..n;               % City indices

array[CITIES, CITIES] of int: cost =     % Travel cost matrix (cost[i,j])
  [| 0, 76, 17, 24
   | 76, 0, 84, 11
   | 17, 84, 0, 90
   | 24, 11, 90, 0 |];

% Variables
array[CITIES] of var CITIES: succ;       % succ[i] = next city visited after city i (a tour)
var int: total_cost;                     % Total travel cost of the tour

% Constraints
include "globals.mzn";

% Enforce a single Hamiltonian cycle visiting every city exactly once
constraint circuit(succ);

% Define total travel cost as the sum of costs along chosen successor arcs
constraint total_cost = sum(i in CITIES) ( cost[i, succ[i]] );

% Objective
solve minimize total_cost;