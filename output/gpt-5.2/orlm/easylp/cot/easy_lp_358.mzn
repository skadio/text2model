% Parameters (with values embedded)
int: c1 = 2;
int: c2 = 3;
int: c3 = 4;
int: c4 = 5;

int: max_x1_plus_x2 = 2000;
int: min_2x3_plus_3x4 = 3000;
int: max_x1_minus_x4 = 500;
int: min_x2_minus_x3 = 1000;

% Since the description mentions "certain bounds" but does not specify them,
% we use safe nonnegative bounds and add implied upper bounds where possible.
int: UB = 10000;

% Variables
var 0..UB: X1;
var 0..UB: X2;
var 0..UB: X3;
var 0..UB: X4;

var 0..(c1*UB + c2*UB + c3*UB + c4*UB): total_cost;

% Constraints
constraint X1 + X2 <= max_x1_plus_x2;

constraint 2*X3 + 3*X4 >= min_2x3_plus_3x4;

% "Difference ... should not exceed 500" interpreted as absolute difference
constraint abs(X1 - X4) <= max_x1_minus_x4;

constraint X2 - X3 >= min_x2_minus_x3;

constraint total_cost = c1*X1 + c2*X2 + c3*X3 + c4*X4;

% Objective
solve minimize total_cost;