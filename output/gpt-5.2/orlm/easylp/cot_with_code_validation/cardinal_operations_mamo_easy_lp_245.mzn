% Parameters
int: X1_lb = 0;
int: X1_ub = 24;
int: X2_lb = 0;
int: X2_ub = 12;
int: X3_lb = 0;
int: X3_ub = 30;

int: c1 = 5;
int: c2 = 6;
int: c3 = 3;

% Variables
var X1_lb..X1_ub: x1;
var X2_lb..X2_ub: x2;
var X3_lb..X3_ub: x3;

var 0..(c1*X1_ub + c2*X2_ub + c3*X3_ub): total_cost;

% Constraints
constraint 2*x1 + 3*x2 + 1*x3 >= 10;
constraint 4*x1 + 5*x2 + 2*x3 <= 20;
constraint 1*x1 - 2*x2 + 1*x3 >= 8;

constraint total_cost = c1*x1 + c2*x2 + c3*x3;

% Objective
solve minimize total_cost;