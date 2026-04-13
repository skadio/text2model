% Parameters (with values embedded)
int: max_units = 10;
int: cost_residential = 50000;
int: cost_commercial = 75000;

float: wX = 0.6;
float: wY = 0.4;
float: min_weighted_sum = 5.0;

% Variables
var 0..max_units: X; % residential units
var 0..max_units: Y; % commercial units

% Constraints
constraint X + Y <= max_units;

% Avoid floats by scaling: 0.6X + 0.4Y >= 5  <=>  6X + 4Y >= 50  <=>  3X + 2Y >= 25
constraint 3 * X + 2 * Y >= 25;

% Objective
var int: total_cost = cost_residential * X + cost_commercial * Y;
solve minimize total_cost;