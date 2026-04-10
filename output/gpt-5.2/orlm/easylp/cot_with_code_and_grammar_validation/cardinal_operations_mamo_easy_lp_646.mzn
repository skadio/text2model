% Parameters
int: c1 = 10;
int: c2 = 15;
int: c3 = 20;
int: c4 = 25;

int: x1_lb = 0;   int: x1_ub = 300;
int: x2_lb = 0;   int: x2_ub = 250;
int: x3_lb = 0;   int: x3_ub = 400;
int: x4_lb = 0;   int: x4_ub = 350;

% Variables
var x1_lb..x1_ub: x1;
var x2_lb..x2_ub: x2;
var x3_lb..x3_ub: x3;
var x4_lb..x4_ub: x4;

var 0..(c1*x1_ub + c2*x2_ub + c3*x3_ub + c4*x4_ub): total_cost;

% Constraints
constraint x1 + x2 >= 200;
constraint abs(x3 - x4) <= 50;

% 2*x2 - x1 - 0.5*x3 <= 100  <=>  4*x2 - 2*x1 - x3 <= 200
constraint 4*x2 - 2*x1 - x3 <= 200;

% (3/4)*x1 = x4 + 150  <=>  3*x1 = 4*x4 + 600
constraint 3*x1 = 4*x4 + 600;

constraint x1 + x2 + x3 + x4 <= 500;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;