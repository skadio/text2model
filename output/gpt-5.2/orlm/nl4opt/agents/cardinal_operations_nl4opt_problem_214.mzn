% Parameters
% (All data embedded as required; no .dzn input)
int: large_capacity = 30;        % cars per large plane
int: small_capacity = 10;        % cars per small plane
int: min_cars = 300;             % minimum cars to deliver

% Variables
% Upper bounds are chosen to be safe and finite based on capacities.
var 0..ceil(min_cars div large_capacity): nLarge;  % number of large planes
var 0..ceil(min_cars div small_capacity): nSmall;  % number of small planes
var 0..1000: totalPlanes;                          % total number of planes (bounded)

% Constraints
% --- Total planes accounting ---
% Ensure totalPlanes correctly sums the two plane types
constraint totalPlanes = nLarge + nSmall;

% --- Demand satisfaction ---
% Deliver at least the required minimum number of cars
constraint large_capacity * nLarge + small_capacity * nSmall >= min_cars;

% --- Environmental / policy constraint ---
% Large planes must be fewer than small planes
constraint nLarge < nSmall;

% Objective
solve minimize totalPlanes;