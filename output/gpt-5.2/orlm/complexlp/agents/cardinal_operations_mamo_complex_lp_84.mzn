% Parameters
int: nCities = 6;                           % Number of cities
set of int: CITIES = 1..nCities;            % City indices

array[CITIES, CITIES] of int: cost =        % Travel cost matrix (cost[i,j])
[
|  0, 23, 50, 92, 56, 91,
| 23,  0, 38, 25, 25, 69,
| 50, 38,  0, 66, 51, 76,
| 92, 25, 66,  0, 97, 37,
| 56, 25, 51, 97,  0, 30,
| 91, 69, 76, 37, 30,  0
];

int: maxCost = max([cost[i,j] | i in CITIES, j in CITIES]);  % For variable bounds

% Variables
array[CITIES] of var CITIES: succ;           % succ[i] = next city visited after city i
var 0..(nCities * maxCost): totalCost;       % Total tour cost (bounded)

% Constraints

% Ensure the tour is a permutation: each city has exactly one successor and
% each city is the successor of exactly one city (one outgoing and one incoming arc)
constraint
  all_different(succ);

% Eliminate subtours: enforce a single Hamiltonian cycle visiting all cities
constraint
  circuit(succ);

% Compute total travel cost from successor representation
constraint
  totalCost = sum(i in CITIES)(cost[i, succ[i]]);

% Objective
solve minimize totalCost;