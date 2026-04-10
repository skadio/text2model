% Parameters
int: tractor_capacity = 40;
int: car_capacity = 20;
int: min_corn = 500;
int: car_to_tractor_ratio = 2;

% Variables
var 0..ceil(min_corn div tractor_capacity) + 100: tractors;
var 0..ceil(min_corn div car_capacity) + 100: cars;

% Constraints
constraint
  tractor_capacity * tractors + car_capacity * cars >= min_corn;

constraint
  cars >= car_to_tractor_ratio * tractors;

% Objective
solve minimize tractors + cars;