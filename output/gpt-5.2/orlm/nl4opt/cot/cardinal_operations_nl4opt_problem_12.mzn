% Parameters (with values embedded)
int: van_capacity = 6;
int: car_capacity = 3;
int: min_voters = 200;
int: max_van_percent = 30;

% Variables
var 0..1000: vans;
var 0..1000: cars;

% Constraints
constraint van_capacity * vans + car_capacity * cars >= min_voters;

% At most 30% of vehicles are vans: vans / (vans + cars) <= 0.30
% Use integer form: 100*vans <= 30*(vans+cars)  -> 70*vans <= 30*cars
constraint 70 * vans <= 30 * cars;

% Objective
solve minimize cars;