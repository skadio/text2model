% Parameters
int: N; % Number of towns to visit
int: StartCity; % Index of the start city
array[1..N, 1..N] of int: Distances; % Distance from city i to city j

% Variables
array[1..N] of var 1..N: Route; % The order of cities to visit
var int: TotalDistance; % The total distance of the route

% Constraints
include "alldifferent.mzn";
constraint alldifferent(Route); % All cities must be visited once
constraint Route[1] = StartCity; % The route starts at the start city
constraint Route[N+1] = StartCity; % The route ends at the start city
constraint TotalDistance = sum(i in 1..N)(Distances[Route[i], Route[i mod N + 1]]); % The total distance is the sum of the distances between consecutive cities

% Objective
solve minimize TotalDistance;