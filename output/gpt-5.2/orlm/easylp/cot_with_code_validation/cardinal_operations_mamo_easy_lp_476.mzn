% Parameters
int: total_budget = 200;
int: max_x = 150;
int: max_y = 100;

float: w_x = 0.6;
float: w_y = 0.8;
float: min_weighted_impact = 120.0;

int: diff_xy_max = 50;

int: cost_x = 50;
int: cost_y = 80;

% Variables
var 0..max_x: X;
var 0..max_y: Y;

var 0..(cost_x*max_x + cost_y*max_y): total_cost;

% Constraints
constraint X + Y <= total_budget;

constraint w_x * int2float(X) + w_y * int2float(Y) >= min_weighted_impact;

constraint X - Y <= diff_xy_max;

constraint total_cost = cost_x * X + cost_y * Y;

% Objective
solve minimize total_cost;