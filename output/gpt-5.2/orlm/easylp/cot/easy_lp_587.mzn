% Parameters (with values embedded)
int: cost1 = 60;
int: cost2 = 50;
int: cost3 = 70;
int: cost4 = 80;

int: x1_lb = 0;  int: x1_ub = 400;
int: x2_lb = 0;  int: x2_ub = 350;
int: x3_lb = 0;  int: x3_ub = 250;
int: x4_lb = 0;  int: x4_ub = 150;

int: cap12 = 500;
int: cap34 = 300;
int: min13 = 200;
int: min_diff = 100;

% Variables
var x1_lb..x1_ub: X1;
var x2_lb..x2_ub: X2;
var x3_lb..x3_ub: X3;
var x4_lb..x4_ub: X4;

var 0..(cost1*x1_ub + cost2*x2_ub + cost3*x3_ub + cost4*x4_ub): total_cost;

% Constraints
constraint X1 + X2 <= cap12;
constraint X3 + X4 <= cap34;
constraint X1 + X3 >= min13;

% Difference between X2 and half of X4 at least 100:
% X2 - 0.5*X4 >= 100  <=>  2*X2 - X4 >= 200
constraint 2*X2 - X4 >= 2*min_diff;

constraint total_cost = cost1*X1 + cost2*X2 + cost3*X3 + cost4*X4;

% Objective
solve minimize total_cost;