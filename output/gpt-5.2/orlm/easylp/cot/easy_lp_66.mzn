% Parameters (with values embedded)
int: min_total_resource = 100;
int: coeff_x = 5;
int: coeff_y = -2;
int: max_strategy_value = 50;
int: cost_x = 10;
int: cost_y = 20;

% Variables
var 0..1000: X;
var 0..1000: Y;
var 0..30000: total_cost;

% Constraints
constraint X + Y >= min_total_resource;
constraint coeff_x * X + coeff_y * Y <= max_strategy_value;
constraint total_cost = cost_x * X + cost_y * Y;

% Objective
solve minimize total_cost;