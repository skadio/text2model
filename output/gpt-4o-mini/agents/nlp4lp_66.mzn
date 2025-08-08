include "globals.mzn";

int: N;  % Number of towns
int: StartCity;  % Index of the start city
array[1..N, 1..N] of int: Distances;  % Distance matrix

% Variables
array[1..N] of var 1..N: tour;  % The order of cities in the tour

% Constraints
constraint tour[1] = StartCity + 1;  % Start from the StartCity (adjusting for 1-based index)
constraint all_different(tour);  % All cities must be visited exactly once

% Objective: Minimize the total distance of the tour
var int: total_distance = sum(i in 1..N-1)(Distances[tour[i], tour[i+1]]) + Distances[tour[N], tour[1]];

% Solve
solve minimize total_distance;

% Output
output [ "Tour = ", show(tour), "\nTotal Distance = ", show(total_distance), "\n" ];