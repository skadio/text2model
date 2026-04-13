% Parameters
int: budget_max = 1000;
int: min_x = 200;
int: min_y = 100;
int: min_z = 50;

int: cost_x = 2;
int: cost_y = 3;
int: cost_z = 4;

% Variables
var min_x..budget_max: x;
var min_y..budget_max: y;
var min_z..budget_max: z;

var 0..(cost_x*budget_max + cost_y*budget_max + cost_z*budget_max): total_cost;

% Constraints
constraint x + y + z <= budget_max;

constraint total_cost = cost_x*x + cost_y*y + cost_z*z;

% Objective
solve minimize total_cost;