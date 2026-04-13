% Parameters
int: cost_X = 10;
int: cost_Y = 15;

int: demand_rhs = 40;
int: cap_rhs = 100;

% Variables
var 0..100: x; % units of product X
var 0..100: y; % units of product Y

var 0..10000: total_cost;

% Constraints
constraint 2 * x + 3 * y >= demand_rhs;
constraint 5 * x + 4 * y <= cap_rhs;

constraint total_cost = cost_X * x + cost_Y * y;

% Objective
solve minimize total_cost;