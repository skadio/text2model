% Parameters (with values embedded)
int: total_resources = 1000;
int: cost_X = 5;
int: cost_Y = 10;
int: cost_Z = 7;

int: min_X = 200;
int: max_Y = 400;
int: min_Z = 150;

% Variables
var 0..total_resources: x; % resources allocated to warehouse X
var 0..total_resources: y; % resources allocated to warehouse Y
var 0..total_resources: z; % resources allocated to warehouse Z

var 0..(cost_X*total_resources + cost_Y*total_resources + cost_Z*total_resources): total_cost;

% Constraints
constraint x >= min_X;
constraint y <= max_Y;
constraint z >= min_Z;

% Use all available resources (allocation problem with a fixed total)
constraint x + y + z = total_resources;

constraint total_cost = cost_X * x + cost_Y * y + cost_Z * z;

% Objective
solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "z=", show(z), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];