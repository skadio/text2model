% Parameters
include "globals.mzn";

int: n = 6;                              % Number of cities
set of int: CITIES = 1..n;               % City indices

% Travel cost matrix (cost[i,j] = cost to go from city i to city j)
array[CITIES, CITIES] of int: cost =
 [|  0, 49, 34, 18, 62, 14
  | 49,  0, 35, 24, 57, 17
  | 34, 35,  0, 20, 34, 58
  | 18, 24, 20,  0, 47, 45
  | 62, 57, 34, 47,  0, 71
  | 14, 17, 58, 45, 71,  0
  |];

int: min_cost = min([cost[i,j] | i,j in CITIES where i != j]); % Minimum non-diagonal cost
int: max_cost = max([cost[i,j] | i,j in CITIES where i != j]); % Maximum non-diagonal cost

% Variables
array[CITIES] of var CITIES: succ;        % succ[i] = next city visited after city i
var int: total_cost;                      % Total tour cost

% Constraints
% Bounds (explicit for linear expressions)
constraint total_cost >= n * min_cost;
constraint total_cost <= n * max_cost;

%---------------------------------------------
% Hamiltonian cycle structure (each city visited exactly once)
%---------------------------------------------
constraint circuit(succ);

%---------------------------------------------
% Prevent self-loops explicitly (redundant with circuit, but clarifies intent)
%---------------------------------------------
constraint forall(i in CITIES) (succ[i] != i);

%---------------------------------------------
% Total cost accumulation along the successor edges
%---------------------------------------------
constraint total_cost = sum(i in CITIES) (cost[i, succ[i]]);

% Objective
solve minimize total_cost;