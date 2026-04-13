% Parameters
int: limit = 5000;
int: diff_min = 100;

float: cost_x = 0.5;
float: cost_y = 0.3;

% Variables
var 0..limit: x;
var 0..limit: y;

var float: total_cost;
var int: total_cost_rounded;

% Constraints
constraint 2 * x + 3 * y <= limit;
constraint x - y >= diff_min;

constraint total_cost = cost_x * int2float(x) + cost_y * int2float(y);

% rounding to nearest integer: floor(v + 0.5) for nonnegative v
constraint total_cost_rounded = floor(total_cost + 0.5);

% Objective
solve minimize total_cost;