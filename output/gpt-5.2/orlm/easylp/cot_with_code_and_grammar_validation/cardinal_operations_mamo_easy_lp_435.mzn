% Parameters
int: min_total_invest = 80;
int: max_diff_invest = 10;
int: max_weighted_diff = 50;

int: cost_X = 200;
int: cost_Y = 100;

% Variables
var 0..1000: x; % investment in option X (whole dollars/units)
var 0..1000: y; % investment in option Y (whole dollars/units)
var 0..1000000: total_cost;

% Constraints
constraint x + y >= min_total_invest;

constraint abs(x - y) <= max_diff_invest;

% 0.6x - 0.4y <= 50  ==>  6x - 4y <= 500
constraint 6*x - 4*y <= 10*max_weighted_diff;

constraint total_cost = cost_X * x + cost_Y * y;

% Objective
solve minimize total_cost;