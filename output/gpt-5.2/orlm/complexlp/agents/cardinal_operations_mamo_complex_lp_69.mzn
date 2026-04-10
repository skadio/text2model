% Parameters
int: nCities = 6;                          % Number of cities (distribution centers)
set of int: CITIES = 1..nCities;           % City indices

% Travel cost matrix: cost[i,j] is the cost to go from city i to city j
% (Embedded directly as required; cost[i,i]=0 but such self-arcs are disallowed by circuit)
array[CITIES, CITIES] of int: cost =
[|  0, 83, 30, 38, 77, 86
 | 96,  0, 93, 13, 65, 47
 | 61, 46,  0, 85, 17, 48
 | 10, 26, 71,  0, 82, 99
 | 87, 42, 53, 66,  0, 12
 | 29, 91,  9, 15, 64,  0
 |];

% Variables
array[CITIES] of var CITIES: succ;         % succ[i] = next city visited after i
array[CITIES] of var CITIES: pred;         % pred[j] = previous city before j
var int: totalCost;                        % Total travel cost of the tour

% Constraints
% --- Tour structure: each city has exactly one successor and one predecessor ---
constraint forall(i in CITIES) (
  pred[succ[i]] = i                        % succ and pred are consistent
);

constraint forall(j in CITIES) (
  succ[pred[j]] = j                        % pred and succ are consistent
);

constraint all_different(succ);            % each city has a unique successor
constraint all_different(pred);            % each city has a unique predecessor

% --- Single Hamiltonian cycle: eliminate subtours ---
constraint circuit(succ);                  % one single tour visiting all cities exactly once

% --- Cost accumulation ---
constraint totalCost = sum(i in CITIES)( cost[i, succ[i]] );

% Objective
solve minimize totalCost;