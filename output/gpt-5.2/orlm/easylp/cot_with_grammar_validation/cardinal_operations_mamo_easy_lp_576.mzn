% Parameters
int: total_resources = 1000;

int: cost_X = 5;
int: cost_Y = 10;
int: cost_Z = 7;

int: min_X = 200;
int: max_Y = 400;
int: min_Z = 150;

% Variables
var 0..total_resources: x;
var 0..total_resources: y;
var 0..total_resources: z;

var 0..(cost_X*total_resources + cost_Y*total_resources + cost_Z*total_resources): total_cost;

% Constraints
constraint x + y + z <= total_resources;

constraint x >= min_X;
constraint y <= max_Y;
constraint z >= min_Z;

constraint total_cost = cost_X * x + cost_Y * y + cost_Z * z;

% Objective
solve minimize total_cost;