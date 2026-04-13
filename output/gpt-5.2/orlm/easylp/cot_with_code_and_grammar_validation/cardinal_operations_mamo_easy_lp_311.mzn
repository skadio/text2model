% Parameters
int: max_units = 1000;
int: min_strength = 200;      % 2*X + 1*Y >= 200
int: min_xz = 300;            % X + Z >= 300

int: cost_x = 300;
int: cost_y = 500;
int: cost_z = 700;

% Variables
var 0..max_units: X;
var 0..max_units: Y;
var 0..max_units: Z;

var 0..(max_units * max(cost_x, max(cost_y, cost_z))): total_cost;

% Constraints
constraint X + Y + Z <= max_units;
constraint 2*X + Y >= min_strength;
constraint X + Z >= min_xz;

constraint total_cost = cost_x*X + cost_y*Y + cost_z*Z;

% Objective
solve minimize total_cost;