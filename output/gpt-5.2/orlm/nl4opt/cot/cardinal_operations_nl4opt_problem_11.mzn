% Parameters (with values embedded)
int: bike_capacity = 3;
int: car_capacity  = 5;
int: min_people    = 500;
int: car_percent_max_num = 40;   % at most 40%
int: car_percent_max_den = 100;

% Variables
var 0..min_people: bikes;
var 0..min_people: cars;

% Constraints
constraint bike_capacity * bikes + car_capacity * cars >= min_people;

% At most 40% of the vehicles can be cars: cars <= 0.4 * (bikes + cars)
% Use integer form to avoid floats: 100*cars <= 40*(bikes+cars)
constraint car_percent_max_den * cars <= car_percent_max_num * (bikes + cars);

% Objective
solve minimize bikes;