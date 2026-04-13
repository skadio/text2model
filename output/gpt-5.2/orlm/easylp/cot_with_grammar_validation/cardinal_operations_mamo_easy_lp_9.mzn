% Parameters
int: budget = 5000;
int: out_x = 10;
int: out_y = 30;
int: required_output = 20000;
int: cost_x = 50;
int: cost_y = 60;

% Variables
var 0..budget: X;
var 0..budget: Y;
var 0..(cost_x*budget + cost_y*budget): total_cost;

% Constraints
constraint X + Y <= budget;
constraint out_x * X + out_y * Y >= required_output;
constraint total_cost = cost_x * X + cost_y * Y;

% Objective
solve minimize total_cost;