% Parameters
int: large_capacity = 30;
int: small_capacity = 10;
int: min_cars = 300;

% Variables
var 0..(min_cars div small_capacity): small_planes;
var 0..(min_cars div large_capacity + 1): large_planes;
var 0..(min_cars div small_capacity + min_cars div large_capacity + 1): total_planes;

% Constraints
constraint large_planes < small_planes;
constraint large_capacity * large_planes + small_capacity * small_planes >= min_cars;
constraint total_planes = large_planes + small_planes;

% Objective
solve minimize total_planes;