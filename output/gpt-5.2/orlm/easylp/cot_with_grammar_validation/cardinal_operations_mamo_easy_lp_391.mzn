% Parameters
int: c1 = 10;
int: c2 = 15;
int: c3 = 25;
int: c4 = 35;

int: min_x1x2 = 20;
int: max_x3x4 = 40;
int: min_x1_minus_2x3 = 5;
int: max_x4_minus_x2 = 10;

% Variables
var int: x1;
var int: x2;
var int: x3;
var int: x4;

var int: total_cost;

% Constraints
constraint x1 + x2 >= min_x1x2;
constraint x3 + x4 <= max_x3x4;
constraint x1 - 2*x3 >= min_x1_minus_2x3;
constraint x4 - x2 <= max_x4_minus_x2;

% Variable bounds implied by problem context (nonnegative allocations)
constraint x1 >= 0;
constraint x2 >= 0;
constraint x3 >= 0;
constraint x4 >= 0;

% Objective linking
constraint total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

% Objective
solve minimize total_cost;