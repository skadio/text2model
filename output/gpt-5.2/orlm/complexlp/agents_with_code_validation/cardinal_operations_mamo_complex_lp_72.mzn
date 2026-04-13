% Parameters
include "globals.mzn";

int: nCities = 5;                         % Number of cities
set of int: CITIES = 1..nCities;          % City index set

array[CITIES, CITIES] of int: cost =      % Travel cost matrix (diagonal = 0)
  [|  0, 58, 15, 75, 91
   | 58,  0, 54, 85, 11
   | 15, 54,  0, 28, 61
   | 75, 85, 28,  0, 47
   | 91, 11, 61, 47,  0 |];

int: minCost = 0;                         % Lower bound on any tour cost
int: maxArcCost = max([cost[i,j] | i in CITIES, j in CITIES]);
int: maxCost = nCities * maxArcCost;      % Safe upper bound on tour cost

% Variables
array[CITIES] of var CITIES: succ;        % succ[i] = next city visited after i
var minCost..maxCost: totalCost;          % Total travel cost of the tour

% Constraints
% --- Tour structure: each city has exactly one successor and one predecessor ---
constraint
  all_different(succ);  % enforces a permutation: unique successor for each city

% --- Single Hamiltonian cycle (no subtours) ---
% Ensures the permutation defined by succ forms one cycle visiting all cities.
constraint
  circuit(succ);

% --- Cost accumulation: totalCost equals sum of chosen arcs ---
constraint
  totalCost = sum(i in CITIES)( cost[i, succ[i]] );

% Objective
solve minimize totalCost;