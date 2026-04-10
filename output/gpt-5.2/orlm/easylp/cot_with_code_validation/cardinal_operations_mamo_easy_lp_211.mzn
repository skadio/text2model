% Parameters
int: total_resources = 100;
int: x_extra = 10;
int: yz_cap = 60;

int: cost_x = 5;
int: cost_y = 3;
int: cost_z = 7;

% Variables
var 0..total_resources: X;
var 0..total_resources: Y;
var 0..total_resources: Z;

var 0..(cost_x*total_resources + cost_y*total_resources + cost_z*total_resources): total_cost;

% Constraints
constraint X + Y + Z <= total_resources;

% X >= Y/2 + 10  (avoid fractions: 2X >= Y + 20)
constraint 2 * X >= Y + 2 * x_extra;

constraint Y + Z <= yz_cap;

constraint total_cost = cost_x * X + cost_y * Y + cost_z * Z;

% Objective
solve minimize total_cost;