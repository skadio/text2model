% Parameters (with values embedded)
int: power_per_unit_X = 60;
int: power_per_unit_Y = 90;

int: capacity_limit = 1200;
int: min_total_allocation = 100;

% Variables
var 0..600: x;  % allocation to plant X (upper bound from 2*x <= 1200)
var 0..400: y;  % allocation to plant Y (upper bound from 3*y <= 1200)

var 0..100000: total_power;

% Constraints
constraint 2*x + 3*y <= capacity_limit;
constraint x >= y;
constraint x + y >= min_total_allocation;

constraint total_power = power_per_unit_X * x + power_per_unit_Y * y;

% Objective
solve minimize total_power;