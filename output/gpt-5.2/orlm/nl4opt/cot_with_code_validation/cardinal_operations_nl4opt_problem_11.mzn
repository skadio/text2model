% Parameters
int: bike_capacity = 3;
int: car_capacity  = 5;
int: min_people    = 500;
int: car_pct_num   = 40;
int: car_pct_den   = 100;

% A safe upper bound: using only bikes
int: max_bikes = (min_people + bike_capacity - 1) div bike_capacity;
int: max_cars  = (min_people + car_capacity - 1) div car_capacity;

% Variables
var 0..max_bikes: bikes;
var 0..max_cars: cars;

% Constraints
constraint bike_capacity * bikes + car_capacity * cars >= min_people;

% cars <= 40% of all vehicles  =>  cars <= 0.4*(bikes+cars)
% Multiply to keep integer arithmetic: 100*cars <= 40*(bikes+cars)
constraint car_pct_den * cars <= car_pct_num * (bikes + cars);

% Objective
solve minimize bikes;