% Parameters (with values embedded)
int: max_total_investment = 100;
int: min_x = 30;
int: min_y = 20;
int: cost_x = 50;
int: cost_y = 60;

% Variables
var 0..max_total_investment: x;
var 0..max_total_investment: y;
var 0..(cost_x*max_total_investment + cost_y*max_total_investment): total_cost;

% Constraints
constraint x >= min_x;
constraint y >= min_y;
constraint x + y <= max_total_investment;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;