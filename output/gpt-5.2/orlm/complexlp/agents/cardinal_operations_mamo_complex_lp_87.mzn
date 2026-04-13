% Parameters
int: nCities = 5;                                % Number of cities
set of int: CITIES = 1..nCities;                 % City index set

% Travel cost matrix (cost[i,j] = cost to go from city i to city j)
array[CITIES, CITIES] of int: cost =
  [|  0, 46, 63, 54, 45
   | 46,  0, 48, 50, 51
   | 63, 48,  0, 31, 64
   | 54, 50, 31,  0, 94
   | 45, 51, 64, 94,  0
  |];

% Variables
array[CITIES] of var CITIES: succ;               % succ[i] = next city visited after i
var int: totalCost;                              % Total tour cost (including return)

% Constraints
% --- Hamiltonian cycle structure: each city has exactly one successor and one predecessor ---
constraint circuit(succ);

% --- Total travel cost accumulation (includes return via successor links) ---
constraint totalCost = sum(i in CITIES)( cost[i, succ[i]] );

% Objective
solve minimize totalCost;