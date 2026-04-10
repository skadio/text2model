% Parameters
int: c1 = 20;
int: c2 = 30;
int: c3 = 50;
int: c4 = 60;

int: x1_lb = 0;  int: x1_ub = 15;
int: x2_lb = 0;  int: x2_ub = 12;
int: x3_lb = 0;  int: x3_ub = 10;
int: x4_lb = 0;  int: x4_ub = 8;

% Variables
var x1_lb..x1_ub: x1;
var x2_lb..x2_ub: x2;
var x3_lb..x3_ub: x3;
var x4_lb..x4_ub: x4;

var 0..(c1*x1_ub + c2*x2_ub + c3*x3_ub + c4*x4_ub): total_cost;

% Constraints
constraint x1 + x2 >= 5;

constraint abs(x3 - x4) <= 10;

constraint 2*x1 + 3*x2 - x4 >= 8;

constraint abs(x1 - x3) <= 6;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;