% Parameters
int: N; % Number of towns to visit
int: StartCity; % Index of the start city
array[1..N, 1..N] of int: Distances; % Distance from city i to city j

% Variables
array[1..N] of var 1..N: Route; % Route of the traveler
var int: TotalDistance; % Total distance of the route

% Constraints
% Each city must be visited exactly once
include "alldifferent.mzn";
constraint alldifferent(Route);

% The first city in the route is the start city
constraint Route[1] = StartCity;

% The last city in the route is also the start city
constraint Route[N] = StartCity;

% The total distance is the sum of the distances between consecutive cities in the route
constraint TotalDistance = sum(i in 1..N-1)(Distances[Route[i], Route[i+1]]);

% Objective
% Minimize the total distance
solve minimize TotalDistance;