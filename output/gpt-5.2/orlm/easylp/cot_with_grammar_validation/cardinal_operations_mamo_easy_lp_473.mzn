% Parameters
int: total_resource_max = 200;
int: effectiveness_min = 150;
int: balance_diff_max = 50;
int: cost_x = 50;
int: cost_y = 80;

% Variables
var 0..total_resource_max: X;
var 0..total_resource_max: Y;
var 0..(cost_x * total_resource_max + cost_y * total_resource_max): total_cost;

% Constraints
constraint X + Y <= total_resource_max;
constraint 2 * X + Y >= effectiveness_min;
constraint abs(X - Y) <= balance_diff_max;

constraint total_cost = cost_x * X + cost_y * Y;

% Objective
solve minimize total_cost;