% Parameters
int: cap_small = 20;
int: cap_large = 50;
int: demand = 2000;
int: min_large = 10;

% Variables
var 0..(demand div cap_small + 100): x_small;
var min_large..(demand div cap_large + 100): x_large;
var 0..(demand div cap_small + demand div cap_large + 200): total_wagons;

% Constraints
constraint cap_small * x_small + cap_large * x_large >= demand;
constraint x_small >= 2 * x_large;
constraint total_wagons = x_small + x_large;

% Objective
solve minimize total_wagons;