% Parameters
int: n = 4;                                % Number of cities
set of int: CITIES = 1..n;                 % City indices

array[CITIES, CITIES] of int: cost =       % Travel cost matrix
  [|  0, 52, 89, 11
   | 52,  0, 14, 13
   | 89, 14,  0, 87
   | 11, 13, 87,  0 |];

% Variables
array[CITIES] of var CITIES: succ;         % succ[i] = next city visited after city i
var int: total_cost;                       % Total travel cost of the tour

% Constraints
include "globals.mzn";

% Hamiltonian tour structure: one single cycle visiting each city exactly once
constraint circuit(succ);

% No self-loops (cannot go from a city to itself)
constraint forall(i in CITIES) (
  succ[i] != i
);

% Total travel cost equals sum of arc costs along the successor edges
constraint total_cost = sum(i in CITIES) (
  cost[i, succ[i]]
);

% Objective
solve minimize total_cost;