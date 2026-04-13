% Parameters
include "globals.mzn";

int: nCities = 6;                         % Number of cities
set of int: CITIES = 1..nCities;          % City indices

array[CITIES, CITIES] of int: cost =      % Travel cost between cities
  [|  0, 43, 39, 97, 84, 67
   | 43,  0, 18, 92, 27, 51
   | 39, 18,  0, 84, 60, 15
   | 97, 92, 84,  0, 42, 32
   | 84, 27, 60, 42,  0, 18
   | 67, 51, 15, 32, 18,  0 |];

int: maxCost = max([cost[i,j] | i in CITIES, j in CITIES]);  % Upper bound helper

% Variables
array[CITIES] of var CITIES: succ;        % succ[i] = next city visited after city i (Hamiltonian cycle)
var 0..(nCities * maxCost): totalCost;    % Total cost of the tour

% Constraints

% Hamiltonian cycle structure: each city has exactly one successor and one predecessor
constraint
  circuit(succ);

% Compute total tour cost as the sum of costs on selected arcs i -> succ[i]
constraint
  totalCost = sum(i in CITIES)( cost[i, succ[i]] );

% Optional tightening: no self-loops (already implied by circuit, but keeps intent clear)
constraint
  forall(i in CITIES)( succ[i] != i );

% Objective
solve minimize totalCost;