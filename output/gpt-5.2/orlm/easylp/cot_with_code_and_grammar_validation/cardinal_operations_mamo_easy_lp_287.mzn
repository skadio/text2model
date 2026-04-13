% Parameters
int: total_budget = 300;
int: min_x = 80;
int: min_y = 60;
int: min_z = 40;

int: cost_x = 50;
int: cost_y = 70;
int: cost_z = 100;

% Variables
var min_x..total_budget: x;
var min_y..total_budget: y;
var min_z..total_budget: z;

var 0..(cost_x*total_budget + cost_y*total_budget + cost_z*total_budget): total_cost;

% Constraints
constraint x + y + z <= total_budget;

constraint total_cost = cost_x*x + cost_y*y + cost_z*z;

% Objective
solve minimize total_cost;