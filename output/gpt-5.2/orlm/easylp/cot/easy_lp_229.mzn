% Parameters (with values embedded)
int: total_resource_max = 1000;
int: min_X = 200;
int: min_Y = 150;
int: min_Z = 250;

int: cost_X = 10;
int: cost_Y = 15;
int: cost_Z = 20;

% Variables
var min_X..total_resource_max: X;
var min_Y..total_resource_max: Y;
var min_Z..total_resource_max: Z;

var 0..(cost_X*total_resource_max + cost_Y*total_resource_max + cost_Z*total_resource_max): total_cost;

% Constraints
constraint X + Y + Z <= total_resource_max;

constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "Minimum total cost ($)=", show(total_cost), "\n"
];