% Parameters
int: max_total_weighted = 50;          % 2*X + 3*Y <= 50
int: min_total_units = 10;             % X + Y >= 10
int: max_abs_diff = 20;                % |X - Y| <= 20
int: cost_X = 100;
int: cost_Y = 200;

% Variables
var 0..25: X;                          % from 2*X <= 50
var 0..16: Y;                          % from 3*Y <= 50
var 0..(cost_X*25 + cost_Y*16): total_cost;

% Constraints
constraint 2*X + 3*Y <= max_total_weighted;
constraint X + Y >= min_total_units;
constraint abs(X - Y) <= max_abs_diff;

constraint total_cost = cost_X*X + cost_Y*Y;

% Objective
solve minimize total_cost;