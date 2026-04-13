% Parameters
int: capacity = 100;
int: x_ub = 70;
int: y_ub = 50;

int: cost_x = 50;
int: cost_y = 80;

int: min_gap = 10;          % X >= 2*Y + 10
int: diff_ub = 20;          % Y - X/2 <= 20  ->  2*Y - X <= 40

% Variables
var 0..x_ub: x;
var 0..y_ub: y;
var 0..(cost_x * x_ub + cost_y * y_ub): total_cost;

% Constraints
constraint x + y <= capacity;

constraint x >= 2 * y + min_gap;

constraint 2 * y - x <= 2 * diff_ub;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;