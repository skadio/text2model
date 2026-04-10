% Parameters
int: cap_limit = 500;
int: min_trucks = 100;
int: balance_limit = 50;

int: coef_cap_x = 2;
int: coef_cap_y = 3;

int: cost_x = 4;
int: cost_y = 6;

% Variables
var 0..cap_limit: x;
var 0..cap_limit: y;

var 0..(cost_x*cap_limit + cost_y*cap_limit): total_cost;

% Constraints
constraint coef_cap_x * x + coef_cap_y * y <= cap_limit;
constraint x + y >= min_trucks;
constraint abs(x - y) <= balance_limit;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;