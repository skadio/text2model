% Parameters
int: c1 = 3;
int: c2 = 2;
int: c3 = 5;

int: max_total = 1000;

int: rhs_2x1_minus_3x3 = 500;

int: max_4x2_plus_x3 = 1200;

int: max_x1 = 400;
int: max_x2 = 300;
int: max_x3 = 600;

% Variables
var 0..max_x1: x1;
var 0..max_x2: x2;
var 0..max_x3: x3;

% Constraints
constraint x1 + x2 + x3 <= max_total;

constraint 2*x1 - 3*x3 >= rhs_2x1_minus_3x3;

constraint 4*x2 + x3 <= max_4x2_plus_x3;

% Objective
var int: total_cost = c1*x1 + c2*x2 + c3*x3;

solve minimize total_cost;