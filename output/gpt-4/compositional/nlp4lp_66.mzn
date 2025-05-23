% Parameters
int: N; % Number of towns to visit
int: StartCity; % Index of the start city
array[1..N, 1..N] of int: Distances; % Distance from city i to city j

% Variables
array[1..N+1] of var 1..N: Route; % The route the traveler takes, starting and ending at the StartCity
var int: TotalDistance; % The total distance of the route

% Constraints

% The route starts and ends at the StartCity
constraint Route[1] = StartCity;
constraint Route[N+1] = StartCity;

% Each city is visited exactly once
constraint alldifferent(Route[1..N]);

% The total distance is the sum of the distances between consecutive cities in the route
constraint TotalDistance = sum(i in 1..N)(Distances[Route[i], Route[i+1]]);

% The route is a cycle, so the order of the cities (except the StartCity) does not matter
constraint increasing(Route[2..N]);

% Objective
solve minimize TotalDistance;