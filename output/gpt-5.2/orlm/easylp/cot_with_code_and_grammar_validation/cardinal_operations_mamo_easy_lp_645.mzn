% Parameters
int: max_x1 = 150;
int: max_x2 = 100;
int: max_x3 = 80;
int: max_x4 = 20;

int: cap_x1x2 = 200;

int: req_strength = 400;          % 2*x1 + 3.5*x3 >= 400
int: max_diff_x2_halfx4 = 50;     % |x2 - 0.5*x4| <= 50
int: max_expr_x2_x1_x3 = 70;      % x2 - x1 - x3 <= 70

int: cost_x1 = 10000;
int: cost_x2 = 5000;
int: cost_x3 = 8000;
int: cost_x4 = 6000;

% Use scaling to avoid fractions:
% 2*x1 + 3.5*x3 >= 400  ==>  4*x1 + 7*x3 >= 800   (multiply by 2)
% |x2 - 0.5*x4| <= 50   ==>  |2*x2 - x4| <= 100   (multiply by 2)
int: strength_rhs_scaled = 800;
int: diff_rhs_scaled = 100;

% Variables
var 0..max_x1: x1;
var 0..max_x2: x2;
var 0..max_x3: x3;
var 0..max_x4: x4;

var 0..(cost_x1*max_x1 + cost_x2*max_x2 + cost_x3*max_x3 + cost_x4*max_x4): total_support;

% Constraints
constraint x1 + x2 <= cap_x1x2;

constraint 4*x1 + 7*x3 >= strength_rhs_scaled;

constraint abs(2*x2 - x4) <= diff_rhs_scaled;

constraint x2 - x1 - x3 <= max_expr_x2_x1_x3;

constraint total_support = cost_x1*x1 + cost_x2*x2 + cost_x3*x3 + cost_x4*x4;

% Objective
solve minimize total_support;