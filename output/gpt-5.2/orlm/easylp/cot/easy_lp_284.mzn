% Parameters (with values embedded)
int: total_resource_limit = 100;
int: cost_X = 500;
int: cost_Y = 300;
int: cost_Z = 700;

int: min_X = 20;
int: min_Y = 30;
int: min_Z = 10;

% Variables
var min_X..total_resource_limit: X;
var min_Y..total_resource_limit: Y;
var min_Z..total_resource_limit: Z;

var 0..(cost_X*total_resource_limit + cost_Y*total_resource_limit + cost_Z*total_resource_limit): total_cost;

% Constraints
constraint X + Y + Z <= total_resource_limit;

% Interpreting "X should be at least twice as much as that subtracted from Y" as: X >= 2*(Y - X)
constraint X >= 2 * (Y - X);

% Interpreting "Y should be at least twice as much as that subtracted from Z" as: Y >= 2*(Z - Y)
constraint Y >= 2 * (Z - Y);

constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;