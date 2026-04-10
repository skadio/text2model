% Parameters
int: cost_x = 20;
int: cost_y = 30;

int: a1x = 5;
int: a1y = 3;
int: rhs1 = 60;

int: a2x = 4;
int: a2y = 1;
int: rhs2 = 80;

int: diff_xy = 10;

int: x_lb = 0;
int: x_ub = 1000;
int: y_lb = 0;
int: y_ub = 500;

% Variables
var x_lb..x_ub: x;
var y_lb..y_ub: y;

var 0..(cost_x * x_ub + cost_y * y_ub): total_cost;

% Constraints
constraint a1x * x + a1y * y >= rhs1;
constraint a2x * x + a2y * y <= rhs2;
constraint x - y >= diff_xy;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;