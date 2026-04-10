% Parameters (with values embedded)
int: tractor_capacity = 40;
int: car_capacity = 20;
int: min_corn = 500;

% Variables
var 0..ceil(min_corn div tractor_capacity): tractors;
var 0..ceil(min_corn div car_capacity) * 2: cars;  % safe upper bound

% Constraints
constraint cars >= 2 * tractors;
constraint tractor_capacity * tractors + car_capacity * cars >= min_corn;

% Objective
solve minimize tractors + cars;