% Parameters
% City indices: 1=E, 2=F, 3=G, 4=H
int: nCities = 4;
set of int: CITIES = 1..nCities;

% Travel cost matrix (cost[i,j] = cost to go from city i to city j)
% Diagonal set to 0 (unused/self travel)
array[CITIES, CITIES] of int: cost =
[
|  0, 17, 52, 79
| 17,  0, 15, 71
| 52, 15,  0, 54
| 79, 71, 54,  0
];

% Variables
% succ[i] = next city visited after city i (defines a Hamiltonian cycle)
array[CITIES] of var CITIES: succ;

% Total travel cost of the tour
var int: total_cost;

% Constraints
% 1) Each city has exactly one outgoing arc (implied by succ domain)
%    and exactly one incoming arc (permutation constraint).
constraint all_different(succ);

% 2) No self-loops: a city cannot go directly to itself.
constraint forall(i in CITIES) (succ[i] != i);

% 3) Ensure the successor mapping forms a single Hamiltonian cycle.
constraint circuit(succ);

% 4) Define total travel cost as the sum of chosen arcs' costs.
constraint total_cost = sum(i in CITIES) (cost[i, succ[i]]);

% Objective
solve minimize total_cost;