% Parameters (with values embedded)
int: total_resources = 100;
int: min_extra_X_over_halfY = 10;
int: max_YZ = 60;

int: cost_X = 5;
int: cost_Y = 3;
int: cost_Z = 7;

% Variables
var 0..total_resources: X;
var 0..total_resources: Y;
var 0..total_resources: Z;

var 0..(cost_X*total_resources + cost_Y*total_resources + cost_Z*total_resources): total_cost;

% Constraints
constraint X + Y + Z = total_resources;
constraint X >= (Y div 2) + min_extra_X_over_halfY;
constraint Y + Z <= max_YZ;

constraint total_cost = cost_X*X + cost_Y*Y + cost_Z*Z;

% Objective
solve minimize total_cost;