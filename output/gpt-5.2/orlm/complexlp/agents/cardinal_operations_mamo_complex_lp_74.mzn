% Parameters
int: nCities = 4;                                % Number of cities
set of int: CITIES = 1..nCities;                 % City index set

array[CITIES, CITIES] of int: cost =             % Travel cost from i to j
  [|  0, 29, 97, 72
   | 29,  0, 69, 52
   | 97, 69,  0, 91
   | 72, 52, 91,  0 |];

% Variables
array[CITIES] of var CITIES: succ;               % succ[i] = next city visited after city i
var 0..sum(i in CITIES, j in CITIES)(cost[i,j]): total_cost;  % Total travel cost (bounded)

% Constraints
% Enforce a single Hamiltonian cycle visiting every city exactly once (no subtours).
% circuit(succ) already implies succ is a permutation, so all_different is redundant but harmless.
constraint circuit(succ);

% Compute total travel cost of the tour induced by succ.
constraint total_cost = sum(i in CITIES)( cost[i, succ[i]] );

% Objective
solve minimize total_cost;