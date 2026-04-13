% Parameters
int: n = 5;                                   % number of cities
set of int: CITIES = 1..n;                    % city indices

array[CITIES, CITIES] of int: cost =          % travel cost matrix
  [|  0, 87, 41, 55, 57
   | 87,  0, 80, 33, 40
   | 41, 80,  0, 90, 42
   | 55, 33, 90,  0, 53
   | 57, 40, 42, 53,  0 |];

% Variables
array[CITIES] of var CITIES: next;            % next[i] = city visited immediately after i
var int: total_cost;                          % total tour cost

% Constraints
include "globals.mzn";

% Hamiltonian tour structure: each city has exactly one successor and one predecessor
constraint circuit(next);

% Total cost computation: sum of costs along all directed edges (i -> next[i])
constraint total_cost = sum(i in CITIES)( cost[i, next[i]] );

% Objective
solve minimize total_cost;