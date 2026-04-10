% Parameters
int: c1 = 6;
int: c2 = 7;
int: c3 = 5;
int: c4 = 4;

int: max_x1x2 = 8;
int: rhs_c3 = 6;

% Variables
var 0..max_x1x2: x1;
var 0..max_x1x2: x2;
var 0..max_x1x2: x4;
var 0..(max_x1x2 + max_x1x2 + rhs_c3): x3;

var int: total_cost;

% Constraints
constraint x1 + x2 <= max_x1x2;

constraint x3 >= x4 + 3;

% 2*x1 + x2 - 2*x3 <= 12  (from x1 + 0.5*x2 - x3 <= 6)
constraint 2*x1 + x2 - 2*x3 <= 2*rhs_c3;

% x2 + 2*x4 - 2*x1 >= 0  (from 0.5*x2 + x4 - x1 >= 0)
constraint x2 + 2*x4 - 2*x1 >= 0;

constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;