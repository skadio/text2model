include "globals.mzn";

% Parameters
int: N; % Number of towns to visit
int: StartCity; % Index of the start city
array[1..N, 1..N] of int: Distances; % Distance from city i to city j

% Variables
array[1..N] of var 1..N: Route; % The route taken by the traveler
var int: TotalDistance; % The total distance traveled

% Constraints
constraint alldifferent(Route); % All cities must be visited once
constraint Route[1] = StartCity; % The traveler starts at the start city
constraint Route[N] = StartCity; % The traveler ends at the start city
constraint forall(i in 1..N-1)(TotalDistance >= Distances[Route[i], Route[i+1]]); % The total distance includes the distance between each pair of cities in the route

% Objective
solve minimize TotalDistance;

% Output
output ["Route: " ++ show(Route) ++ "\nTotal Distance: " ++ show(TotalDistance)];