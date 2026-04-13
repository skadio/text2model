% Parameters
int: budget = 20;
int: min_impact = 10;

int: cost_x = 4;
int: cost_y = 5;

% Variables
var 0..budget: x;
var 0..budget: y;
var 0..(cost_x*budget + cost_y*budget): total_cost;

% Constraints
constraint x + y <= budget;
constraint 2*x + y >= min_impact;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;