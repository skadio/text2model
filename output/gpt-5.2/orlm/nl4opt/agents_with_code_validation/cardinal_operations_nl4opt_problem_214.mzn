% Parameters
int: large_capacity = 30;          % Cars carried by one large plane
int: small_capacity = 10;          % Cars carried by one small plane
int: min_cars = 300;               % Minimum number of cars to deliver

% Variables
var 0..ceil(min_cars / large_capacity): num_large_planes;  % Number of large planes used
var 0..ceil(min_cars / small_capacity): num_small_planes;  % Number of small planes used
var 0..(ceil(min_cars / large_capacity) + ceil(min_cars / small_capacity)): total_planes; % Total planes used

% Constraints
% Total planes is the sum of large and small planes
constraint total_planes = num_large_planes + num_small_planes;

% Ensure the shipped cars meet or exceed the minimum requirement
constraint large_capacity * num_large_planes + small_capacity * num_small_planes >= min_cars;

% Pollution restriction: number of large planes must be less than number of small planes
constraint num_large_planes < num_small_planes;

% Objective
solve minimize total_planes;