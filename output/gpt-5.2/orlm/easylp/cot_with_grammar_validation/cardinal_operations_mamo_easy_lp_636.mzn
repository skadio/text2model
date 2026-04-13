% Parameters
int: c1 = 300;
int: c2 = 200;
int: c3 = 100;
int: c4 = 50;

int: b12_max = 500;

int: req_2x1_3p5x3_min = 700;

int: diff_x2_halfx3_x1_max = 300;

int: diff_halfx4_x2_max = 400;

int: x4_le_x1_minus = 150;

% Variables
var 0..10000: x1;
var 0..10000: x2;
var 0..10000: x3;
var 0..10000: x4;

var int: total_cost;

% Constraints
constraint x1 + x2 <= b12_max;

% 2*x1 + 3.5*x3 >= 700  <=>  4*x1 + 7*x3 >= 1400
constraint 4*x1 + 7*x3 >= 2 * req_2x1_3p5x3_min;

% x2 - 0.5*x3 - x1 <= 300  <=>  2*x2 - x3 - 2*x1 <= 600
constraint 2*x2 - x3 - 2*x1 <= 2 * diff_x2_halfx3_x1_max;

% 0.5*x4 - x2 <= 400  <=>  x4 - 2*x2 <= 800
constraint x4 - 2*x2 <= 2 * diff_halfx4_x2_max;

constraint x4 <= x1 - x4_le_x1_minus;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;