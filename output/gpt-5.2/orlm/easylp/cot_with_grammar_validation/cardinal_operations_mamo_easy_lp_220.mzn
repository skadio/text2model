% Parameters
int: total_budget = 1000;
int: min_x = 300;
int: min_y = 200;
int: min_z = 500;

int: cost_x = 10;
int: cost_y = 8;
int: cost_z = 6;

% Variables
var min_x..total_budget: x;
var min_y..total_budget: y;
var min_z..total_budget: z;

var 0..(cost_x*total_budget + cost_y*total_budget + cost_z*total_budget): total_cost;

% Constraints
constraint x + y + z <= total_budget;

constraint total_cost = cost_x * x + cost_y * y + cost_z * z;

% Objective
solve minimize total_cost;