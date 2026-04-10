% Parameters
int: van_capacity = 6;
int: car_capacity = 3;
int: min_voters = 200;
float: max_van_fraction = 0.30;

% Variables
var 0..min_voters: vans;
var 0..min_voters: cars;

% Constraints
constraint van_capacity * vans + car_capacity * cars >= min_voters;

% At most 30% of the vehicles can be vans:
% vans <= 0.30 * (vans + cars)  <=>  70*vans <= 30*cars
constraint 70 * vans <= 30 * cars;

% Objective
solve minimize cars;