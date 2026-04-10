% Parameters (with values embedded)
int: total_budget_max = 200;
int: x_max = 150;
int: y_max = 100;

% Use scaled integers to avoid floats:
% 0.6*x + 0.8*y >= 120  <=>  6*x + 8*y >= 1200
int: impact_rhs = 1200;

int: cost_x = 50;
int: cost_y = 80;

% Variables
var 0..x_max: x;
var 0..y_max: y;
var 0..(cost_x*x_max + cost_y*y_max): total_cost;

% Constraints
constraint x + y <= total_budget_max;
constraint 6*x + 8*y >= impact_rhs;
constraint x - y <= 50;

constraint total_cost = cost_x*x + cost_y*y;

% Objective
solve minimize total_cost;