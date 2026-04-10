% Parameters
int: cost_x1 = 10;
int: cost_x2 = 20;
int: cost_x3 = 30;
int: cost_x4 = 40;

int: cap_x1x2 = 1000;
int: cap_x3x4 = 2000;

int: min_diff_x3_x1 = 500;
int: min_diff_x4_x2 = 300;

int: ub_x1 = 700;
int: ub_x2 = 800;
int: ub_x3 = 900;
int: ub_x4 = 1000;

% Variables
var 0..ub_x1: x1;
var 0..ub_x2: x2;
var 0..ub_x3: x3;
var 0..ub_x4: x4;

var int: total_cost;

% Constraints
constraint x1 + x2 <= cap_x1x2;
constraint x3 + x4 <= cap_x3x4;

constraint x3 >= x1 + min_diff_x3_x1;
constraint x4 >= x2 + min_diff_x4_x2;

constraint total_cost = cost_x1*x1 + cost_x2*x2 + cost_x3*x3 + cost_x4*x4;

% Objective
solve minimize total_cost;