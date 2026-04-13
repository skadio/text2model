% Parameters
int: van_capacity = 6;
int: car_capacity = 3;
int: min_voters = 200;
float: max_van_fraction = 0.30;

% Variables
var 0..min_voters: vans;
var 0..min_voters: cars;
var 0..(van_capacity*min_voters + car_capacity*min_voters): total_voters;

% Constraints
constraint total_voters = van_capacity * vans + car_capacity * cars;
constraint total_voters >= min_voters;

% At most 30% of vehicles are vans: vans <= 0.30 * (vans + cars)
% Use integer form to avoid floats: 10*vans <= 3*(vans+cars)  <=> 7*vans <= 3*cars
constraint 7 * vans <= 3 * cars;

% Objective
solve minimize cars;