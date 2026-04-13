% Parameters
int: max_total_resource = 1000;
int: coef_X = 2;
int: coef_Y = 3;
int: min_diff_XY = 100;
int: red_X = 5;
int: red_Y = 7;

% Variables
var 0..(max_total_resource div coef_X): x;
var 0..(max_total_resource div coef_Y): y;
var int: total_cost;

% Constraints
constraint coef_X * x + coef_Y * y <= max_total_resource;
constraint x >= y + min_diff_XY;

constraint total_cost = -(red_X * x + red_Y * y);

% Objective
solve minimize total_cost;