% Parameters
int: a = 5;
int: b = 3;
int: budget = 500;

int: min_sum = 60;

int: diff_a = 1;      % x coefficient in difference constraint
int: diff_b = 2;      % y coefficient in difference constraint (as 2*y)
int: diff_ub = 30;

int: cost_x = 50;
int: cost_y = 70;

% Variables
var 0..budget div a: x;
var 0..budget div b: y;

var int: total_cost;

% Constraints
constraint a * x + b * y <= budget;
constraint x + y >= min_sum;
constraint x - diff_b * y <= diff_ub;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;