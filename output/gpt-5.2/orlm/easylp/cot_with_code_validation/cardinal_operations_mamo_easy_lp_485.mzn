% Parameters
int: budget = 100;
int: impact_x = 3;
int: impact_y = 4;
int: min_impact = 300;
int: max_diff = 20;
int: cost_x = 5;
int: cost_y = 2;

% Variables
var 0..budget: x;
var 0..budget: y;
var 0..(cost_x*budget + cost_y*budget): total_cost;

% Constraints
constraint x + y <= budget;

constraint impact_x * x + impact_y * y >= min_impact;

constraint abs(x - y) <= max_diff;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;