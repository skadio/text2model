% Parameters
int: total_budget = 1000;
int: min_diff_XY = 200;
int: max_Z = 300;

int: cost_X = 50;
int: cost_Y = 30;
int: cost_Z = 20;

% Variables
var 0..total_budget: X;
var 0..total_budget: Y;
var 0..max_Z: Z;
var 0..(cost_X*total_budget + cost_Y*total_budget + cost_Z*total_budget): total_cost;

% Constraints
constraint X + Y + Z = total_budget;
constraint X >= Y + min_diff_XY;

constraint total_cost = cost_X*X + cost_Y*Y + cost_Z*Z;

% Objective
solve minimize total_cost;