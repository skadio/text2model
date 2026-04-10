% Parameters
int: nCities = 5;                         % number of cities
set of int: CITIES = 1..nCities;          % city indices

array[CITIES, CITIES] of int: cost =      % travel cost matrix
  [|  0, 73, 39, 79, 38
   | 73,  0, 30, 46, 29
   | 39, 30,  0, 88, 57
   | 79, 46, 88,  0, 59
   | 38, 29, 57, 59,  0 |];

% Variables
array[CITIES] of var CITIES: succ;        % succ[i] = next city visited after i (defines a Hamiltonian cycle)
var int: total_cost;                      % total travel cost of the Hamiltonian cycle

% Bounds / basic constraints on variables used in linear expressions
constraint total_cost >= 0;

% Constraints

% Ensure each city has exactly one successor and one predecessor (forms a single tour)
constraint circuit(succ);

% Disallow self-loops explicitly (redundant with circuit, kept for clarity)
constraint forall(i in CITIES) (succ[i] != i);

% Compute total travel cost of the Hamiltonian cycle
constraint total_cost = sum(i in CITIES) (cost[i, succ[i]]);

% Objective
solve minimize total_cost;