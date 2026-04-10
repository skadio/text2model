% Parameters
int: min_total_invest = 80;
int: max_diff_xy = 10;
int: max_weighted_diff = 50;

int: cost_x = 200;
int: cost_y = 100;

% Use integer scaling for 0.6 and 0.4: 0.6*X - 0.4*Y <= 50  <=>  6*X - 4*Y <= 500
int: w_x = 6;
int: w_y = 4;
int: w_rhs = 500;

% Variables
% Investments must be whole numbers (nonnegative integers)
var 0..100000: X;
var 0..100000: Y;

var 0..100000000: total_cost;

% Constraints
constraint X + Y >= min_total_invest;

constraint X - Y <= max_diff_xy;
constraint Y - X <= max_diff_xy;

constraint w_x * X - w_y * Y <= w_rhs;

constraint total_cost = cost_x * X + cost_y * Y;

% Objective
solve minimize total_cost;