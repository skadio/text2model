% Parameters (with values embedded)
int: max_resources = 100;
int: min_strength_xy = 50;   % 2*X + Y >= 50
int: min_strength_xz = 40;   % X + Z >= 40

int: cost_x = 5000;
int: cost_y = 4000;
int: cost_z = 6000;

% Variables
var 0..max_resources: X;
var 0..max_resources: Y;
var 0..max_resources: Z;

var 0..(max_resources * max([cost_x, cost_y, cost_z])): total_cost;

% Constraints
constraint X + Y + Z <= max_resources;
constraint 2 * X + Y >= min_strength_xy;
constraint X + Z >= min_strength_xz;

constraint total_cost = cost_x * X + cost_y * Y + cost_z * Z;

% Objective
solve minimize total_cost;