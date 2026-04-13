% Parameters
int: c1 = 100;
int: c2 = 200;
int: c3 = 150;
int: c4 = 250;

int: x1_lb = 0;    int: x1_ub = 5000;
int: x2_lb = 0;    int: x2_ub = 5000;
int: x3_lb = 0;    int: x3_ub = 6000;
int: x4_lb = 0;    int: x4_ub = 6000;

int: max_x1x2 = 5000;
int: max_x3x4 = 6000;
int: min_x1x3 = 3000;
int: min_x2x4 = 4000;

% Variables
var x1_lb..x1_ub: x1;
var x2_lb..x2_ub: x2;
var x3_lb..x3_ub: x3;
var x4_lb..x4_ub: x4;

var 0..(c1*x1_ub + c2*x2_ub + c3*x3_ub + c4*x4_ub): total_cost;

% Constraints
constraint x1 + x2 <= max_x1x2;
constraint x3 + x4 <= max_x3x4;

constraint x1 + x3 >= min_x1x3;
constraint x2 + x4 >= min_x2x4;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;