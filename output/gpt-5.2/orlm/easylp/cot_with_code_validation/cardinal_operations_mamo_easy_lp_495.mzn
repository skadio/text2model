% Parameters
int: max_weight = 500;
int: min_trucks = 100;
int: max_diff = 50;

int: cost_x = 4;
int: cost_y = 6;

int: coef_x = 2;
int: coef_y = 3;

% Variables
var 0..max_weight: x;  % trucks on route X
var 0..max_weight: y;  % trucks on route Y
var 0..(cost_y * max_weight): total_cost;

% Constraints
constraint coef_x * x + coef_y * y <= max_weight;
constraint x + y >= min_trucks;
constraint abs(x - y) <= max_diff;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;