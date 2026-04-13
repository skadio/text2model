% Parameters (with values embedded)
int: max_x1 = 800;
int: max_x2 = 700;
int: max_x3 = 500;
int: max_x4 = 200;

int: cap_x1_x2 = 1000;
int: cap_2x3_3x4 = 1500;

int: min_x1_minus_half_x3 = 300;
int: max_x4_minus_x2 = 400;

int: cost_x1 = 50;
int: cost_x2 = 60;
int: cost_x3 = 30;
int: cost_x4 = 20;

% Variables
var 0..max_x1: x1;
var 0..max_x2: x2;
var 0..max_x3: x3;
var 0..max_x4: x4;

var 0..(cost_x1*max_x1 + cost_x2*max_x2 + cost_x3*max_x3 + cost_x4*max_x4): total_cost;

% Constraints
constraint x1 + x2 <= cap_x1_x2;
constraint 2*x3 + 3*x4 <= cap_2x3_3x4;

% x1 should exceed half of x3 by at least 300:
% x1 - (x3/2) >= 300  <=>  2*x1 - x3 >= 600
constraint 2*x1 - x3 >= 2*min_x1_minus_half_x3;

% difference between x4 and x2 should not surpass 400: x4 - x2 <= 400
constraint x4 - x2 <= max_x4_minus_x2;

constraint total_cost = cost_x1*x1 + cost_x2*x2 + cost_x3*x3 + cost_x4*x4;

% Objective
solve minimize total_cost;