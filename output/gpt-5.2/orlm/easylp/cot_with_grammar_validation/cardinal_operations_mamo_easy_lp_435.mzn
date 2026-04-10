% Parameters
int: min_total_invest = 80;
int: max_diff_xy = 10;
int: max_weighted_diff = 50;

int: cost_x = 200;
int: cost_y = 100;

% Use integer-scaled percentages to avoid floats:
% 0.6*X - 0.4*Y <= 50  <=>  6*X - 4*Y <= 500
int: w_x = 6;
int: w_y = 4;
int: w_rhs = 500;

% Variable bounds (tight, derived):
% From X+Y >= 80 and |X-Y| <= 10, minimal feasible X,Y are around 35..45.
int: lb_xy = 0;
int: ub_xy = 1000;

% Variables
var lb_xy..ub_xy: X;
var lb_xy..ub_xy: Y;
var 0..(cost_x*ub_xy + cost_y*ub_xy): total_cost;

% Constraints
constraint X + Y >= min_total_invest;

constraint abs(X - Y) <= max_diff_xy;

constraint w_x * X - w_y * Y <= w_rhs;

constraint total_cost = cost_x * X + cost_y * Y;

% Objective
solve minimize total_cost;