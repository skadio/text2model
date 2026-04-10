% Parameters
int: nCities = 5;                           % number of cities
set of int: CITIES = 1..nCities;            % city index set

array[CITIES, CITIES] of int: cost =        % travel cost matrix
[
  % to:   1   2   3   4   5
  /*1*/ [ 0, 87, 41, 55, 57],
  /*2*/ [87,  0, 80, 33, 40],
  /*3*/ [41, 80,  0, 90, 42],
  /*4*/ [55, 33, 90,  0, 53],
  /*5*/ [57, 40, 42, 53,  0]
];

int: maxCost = max([cost[i,j] | i in CITIES, j in CITIES]);  % upper bound helper

% Variables
array[CITIES] of var CITIES: succ;           % succ[i] = next city visited after i
var 0..(nCities * maxCost): total_cost;      % objective: total tour cost (bounded)

% Constraints
% Ensure the tour is a single Hamiltonian cycle visiting each city exactly once
constraint circuit(succ);

% Compute total travel cost of the tour defined by succ
constraint total_cost = sum(i in CITIES)( cost[i, succ[i]] );

% Objective
solve minimize total_cost;