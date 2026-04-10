% Parameters
int: budget_max = 5000;
int: x_min = 2000;
int: y_max = 1000;
int: z_min = 500;

int: cost_x = 50;
int: cost_y = 100;
int: cost_z = 150;

% Variables
var 0..budget_max: x;
var 0..budget_max: y;
var 0..budget_max: z;

var 0..(budget_max * max([cost_x, cost_y, cost_z])): total_cost;

% Constraints
constraint x + y + z <= budget_max;

constraint x >= x_min;
constraint y <= y_max;
constraint z >= z_min;

constraint total_cost = cost_x * x + cost_y * y + cost_z * z;

% Objective
solve minimize total_cost;