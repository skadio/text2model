% Parameters
int: budget = 5000;
int: out_x = 10;
int: out_y = 30;
int: out_req = 20000;
int: cost_x = 50;
int: cost_y = 60;

% Variables
var 0..budget: x;
var 0..budget: y;
var 0..(cost_x*budget + cost_y*budget): total_cost;

% Constraints
constraint x + y <= budget;
constraint out_x * x + out_y * y >= out_req;
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;