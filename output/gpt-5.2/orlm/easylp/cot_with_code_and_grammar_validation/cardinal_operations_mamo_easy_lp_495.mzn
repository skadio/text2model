% Parameters
int: cap_limit = 500;
int: min_trucks = 100;
int: max_diff = 50;

int: cap_x_coeff = 2;
int: cap_y_coeff = 3;

int: cost_x = 4;
int: cost_y = 6;

% Variables
var 0..cap_limit: x; % trucks on route X
var 0..cap_limit: y; % trucks on route Y
var 0..(cost_x*cap_limit + cost_y*cap_limit): total_cost;

% Constraints
constraint cap_x_coeff * x + cap_y_coeff * y <= cap_limit;
constraint x + y >= min_trucks;
constraint abs(x - y) <= max_diff;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;