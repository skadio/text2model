include "globals.mzn";

% Number of cities
int: N;

% Index of the start city
int: StartCity;

% Distance from city i to city j
array[1..N, 1..N] of int: Distances;

% Decision variables
array[1..N] of var 1..N: Cities;
var int: TotalDistance;

% The city sequence must be a permutation of the cities
constraint alldifferent(Cities);

% The first city is the start city
constraint Cities[1] = StartCity;

% The total distance is the sum of the distances between consecutive cities, plus the distance back to the start city
constraint TotalDistance = sum(i in 1..N-1)(Distances[Cities[i], Cities[i+1]]) + Distances[Cities[N], Cities[1]];

% Minimize the total distance
solve minimize TotalDistance;

% Output the solution
output ["Total distance: ", show(TotalDistance), "\n"] ++
["Cities sequence: "] ++ [if i < N then show(Cities[i]) ++ " -> " else show(Cities[i]) endif | i in 1..N];