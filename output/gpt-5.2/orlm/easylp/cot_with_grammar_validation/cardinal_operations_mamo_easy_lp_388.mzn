% Parameters
int: c1 = 50;
int: c2 = 100;
int: c3 = 200;
int: c4 = 300;

int: x1_lb = 0;   int: x1_ub = 500;
int: x2_lb = 0;   int: x2_ub = 400;
int: x3_lb = 0;   int: x3_ub = 600;
int: x4_lb = 0;   int: x4_ub = 700;

int: max_x1_x2 = 500;
int: min_x2_x3 = 300;
int: max_diff_x3_x4 = 100;
int: min_diff_x4_x1 = 50;

% Variables
var x1_lb..x1_ub: x1;
var x2_lb..x2_ub: x2;
var x3_lb..x3_ub: x3;
var x4_lb..x4_ub: x4;

var 0..(c1*x1_ub + c2*x2_ub + c3*x3_ub + c4*x4_ub): total_cost;

% Constraints
constraint x1 + x2 <= max_x1_x2;
constraint x2 + x3 >= min_x2_x3;

constraint abs(x3 - x4) <= max_diff_x3_x4;
constraint x4 - x1 >= min_diff_x4_x1;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;