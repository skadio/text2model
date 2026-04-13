% Parameters
int: bike_capacity = 3;
int: car_capacity  = 5;
int: min_people    = 500;
float: max_car_frac = 0.4;

% Variables
var 0..min_people: bikes;
var 0..min_people: cars;

% Constraints
constraint bike_capacity * bikes + car_capacity * cars >= min_people;
constraint cars <= max_car_frac * (bikes + cars);

% Objective
solve minimize bikes;