% Parameters
% Cost coefficients for each promotional activity
int: c1 = 2;
int: c2 = 3;
int: c3 = 5;
int: c4 = 4;

% Constraint right-hand sides
int: rhs_x1_x2_max = 100;      % x1 + x2 <= 100
int: rhs_2x1_x3_min = 150;     % 2*x1 + x3 >= 150
int: rhs_x2_3x4_max = 50;      % x2 - 3*x4 <= 50
int: rhs_x3_x4_min_diff = 20;  % x3 - x4 >= 20

% (Safe) variable upper bound derived from constraints to keep domain bounded
int: UB = 1000;

% Variables
var 0..UB: x1;  % Budget allocation to activity x1 (integer, nonnegative)
var 0..UB: x2;  % Budget allocation to activity x2 (integer, nonnegative)
var 0..UB: x3;  % Budget allocation to activity x3 (integer, nonnegative)
var 0..UB: x4;  % Budget allocation to activity x4 (integer, nonnegative)

% Constraints
% Budget cap on combined allocation for activities x1 and x2
constraint x1 + x2 <= rhs_x1_x2_max;

% Minimum requirement linking activity x1 and x3 allocations
constraint 2 * x1 + x3 >= rhs_2x1_x3_min;

% Upper bound relationship between x2 and x4 allocations
constraint x2 - 3 * x4 <= rhs_x2_3x4_max;

% Minimum difference between x3 and x4 allocations
constraint x3 - x4 >= rhs_x3_x4_min_diff;

% Objective
solve minimize c1 * x1 + c2 * x2 + c3 * x3 + c4 * x4;