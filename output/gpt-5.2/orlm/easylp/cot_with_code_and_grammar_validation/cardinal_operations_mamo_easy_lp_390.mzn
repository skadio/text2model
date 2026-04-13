% Parameters
int: c1 = 200;
int: c2 = 100;
int: c3 = 500;
int: c4 = 300;

int: x1_lb = 0;  int: x1_ub = 20;
int: x2_lb = 0;  int: x2_ub = 30;
int: x3_lb = 0;  int: x3_ub = 15;
int: x4_lb = 0;  int: x4_ub = 20;

% Variables
var x1_lb..x1_ub: x1;
var x2_lb..x2_ub: x2;
var x3_lb..x3_ub: x3;
var x4_lb..x4_ub: x4;

var 0..(c1*x1_ub + c2*x2_ub + c3*x3_ub + c4*x4_ub): total_cost;

% Constraints
constraint x1 + x2 <= 25;
constraint x3 + x4 <= 15;
constraint x1 + x3 >= 10;
constraint x2 + x4 >= 20;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;