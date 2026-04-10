% Parameters (with values embedded)
int: max_total_units = 50;
int: min_weighted_units = 30;

int: cost_x = 500; % residential
int: cost_y = 700; % commercial
int: cost_z = 900; % industrial

% Individual upper limits (not specified; use total limit as the tightest known bound)
int: max_x = max_total_units;
int: max_y = max_total_units;
int: max_z = max_total_units;

% Variables
var 0..max_x: x; % residential units
var 0..max_y: y; % commercial units
var 0..max_z: z; % industrial units

var 0..(cost_x*max_x + cost_y*max_y + cost_z*max_z): total_cost;

% Constraints
constraint x + y + z <= max_total_units;
constraint 2*x + 3*y + z >= min_weighted_units;
constraint abs(x - y) <= 10;
constraint y >= z + 5;

constraint total_cost = cost_x*x + cost_y*y + cost_z*z;

% Objective
solve minimize total_cost;