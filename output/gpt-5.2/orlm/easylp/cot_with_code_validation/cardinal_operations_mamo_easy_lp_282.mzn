% Parameters
int: total_budget = 5000;
int: min_x = 1500;
int: min_y = 800;
int: min_z = 700;

int: cost_x = 100;
int: cost_y = 200;
int: cost_z = 50;

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