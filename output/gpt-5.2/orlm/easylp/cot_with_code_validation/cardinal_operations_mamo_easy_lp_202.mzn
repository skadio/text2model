% Parameters
int: total_budget = 5000;
int: min_x_over_2y = 1000;
int: min_z_over_y = 1500;

int: cost_x = 10;
int: cost_y = 15;
int: cost_z = 20;

% Variables
var 0..total_budget: X;
var 0..total_budget: Y;
var 0..total_budget: Z;

var 0..(cost_x*total_budget + cost_y*total_budget + cost_z*total_budget): total_cost;

% Constraints
constraint X + Y + Z <= total_budget;

constraint X >= 2*Y + min_x_over_2y;
constraint Z >= Y + min_z_over_y;

constraint total_cost = cost_x*X + cost_y*Y + cost_z*Z;

% Objective
solve minimize total_cost;