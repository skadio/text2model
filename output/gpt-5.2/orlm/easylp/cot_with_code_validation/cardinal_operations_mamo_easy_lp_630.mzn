% Parameters
int: c1 = 500;
int: c2 = 600;
int: c3 = 800;
int: c4 = 700;

int: max12 = 100;
int: max34 = 50;

int: min_diff = 30;

% Variable bounds (not explicitly provided in the description; assume non-negative integers)
int: lb1 = 0; int: ub1 = 100;
int: lb2 = 0; int: ub2 = 100;
int: lb3 = 0; int: ub3 = 50;
int: lb4 = 0; int: ub4 = 50;

% Variables
var lb1..ub1: x1;
var lb2..ub2: x2;
var lb3..ub3: x3;
var lb4..ub4: x4;

var 0..(c1*ub1 + c2*ub2 + c3*ub3 + c4*ub4): total_cost;

% Constraints
constraint x1 + x2 <= max12;
constraint x3 + x4 <= max34;

constraint x3 >= 2 * x1;
constraint 4 * x4 >= 3 * x2;

constraint (x3 + x4) - (x1 + x2) >= min_diff;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;