% Parameters
int: logi_coef_x = 10;
int: logi_coef_y = 20;
int: logi_limit = 3000;

int: strength_coef_x = 3;
int: strength_coef_y = 5;
int: strength_min = 500;

int: balance_max_diff = 1000;

int: cost_x = 10000;
int: cost_y = 20000;

% Variables
var 0..300: x;
var 0..150: y;
var 0..(cost_x*300 + cost_y*150): total_cost;

% Constraints
constraint logi_coef_x * x + logi_coef_y * y <= logi_limit;

constraint strength_coef_x * x + strength_coef_y * y >= strength_min;

constraint abs(x - y) <= balance_max_diff;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;