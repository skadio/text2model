% Parameters
int: total_budget = 1000;
int: min_x = 200;
int: min_y = 150;
int: min_z = 100;

int: cost_x = 50;
int: cost_y = 60;
int: cost_z = 70;

% Variables
var min_x..total_budget: X;
var min_y..total_budget: Y;
var min_z..total_budget: Z;

var 0..(cost_x*total_budget + cost_y*total_budget + cost_z*total_budget): total_cost;

% Constraints
constraint X + Y + Z <= total_budget;

constraint total_cost = cost_x * X + cost_y * Y + cost_z * Z;

% Objective
solve minimize total_cost;