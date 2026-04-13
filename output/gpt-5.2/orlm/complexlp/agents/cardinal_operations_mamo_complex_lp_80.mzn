% Parameters
int: nCities = 4;                          % number of cities
set of int: CITIES = 1..nCities;           % city indices

array[CITIES, CITIES] of int: cost =       % travel cost from i to j
  [|  0, 17, 25, 31
   | 17,  0, 93, 45
   | 25, 93,  0, 95
   | 31, 45, 95,  0 |];

% Variables
array[CITIES] of var CITIES: succ;         % successor city visited after city i
var int: totalCost;                        % total tour cost (sum of chosen arcs)

% Constraints

% Eliminate subtours and enforce a single Hamiltonian cycle over all cities
% (subcircuit already implies succ is a permutation for a single cycle covering all nodes)
constraint
  subcircuit(succ);

% Compute total travel cost as the sum of costs along chosen successor arcs
constraint
  totalCost = sum(i in CITIES)(cost[i, succ[i]]);

% Objective
solve minimize totalCost;