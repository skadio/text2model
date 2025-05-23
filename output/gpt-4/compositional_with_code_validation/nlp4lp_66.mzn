% Parameters
int: N; % Number of towns to visit
int: StartCity; % Index of the start city
array[1..N, 1..N] of int: Distances; % Distance from city i to city j

% Variables
array[1..N+1] of var 1..N: Route; % The route the traveler takes, starting and ending at the StartCity
var int: TotalDistance; % The total distance of the route

% Constraints

% The route must start and end at the StartCity
constraint Route[1] = StartCity;
constraint Route[N+1] = StartCity;

% Each city must be visited exactly once
constraint alldifferent(Route[1..N]);

% The total distance is the sum of the distances between consecutive cities in the route
constraint TotalDistance = sum(i in 1..N)(Distances[Route[i], Route[i+1]]);

% Objective
solve minimize TotalDistance;