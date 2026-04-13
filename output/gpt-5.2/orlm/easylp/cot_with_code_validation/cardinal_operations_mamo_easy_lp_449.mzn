% Parameters
int: cost_x = 500;
int: cost_y = 1000;

int: a1x = 5;
int: a1y = 2;
int: rhs1 = 10;

int: a2x = 3;
int: a2y = 4;
int: rhs2 = 25;

int: x_lb = 0;
int: x_ub = 7;
int: y_lb = 0;
int: y_ub = 5;

int: min_diff = 1;

% Variables
var x_lb..x_ub: x;
var y_lb..y_ub: y;
var 0..(cost_x * x_ub + cost_y * y_ub): total_cost;

% Constraints
constraint a1x * x + a1y * y >= rhs1;
constraint a2x * x + a2y * y <= rhs2;
constraint x - y >= min_diff;
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;