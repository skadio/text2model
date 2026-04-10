% Parameters
% Unit costs
int: c1 = 300;
int: c2 = 200;
int: c3 = 500;
int: c4 = 400;

% Constraint constants
int: max_x1_x2 = 1000;      % x1 + x2 <= 1000
int: min_2x1_x3 = 800;      % 2*x1 + x3 >= 800
int: min_x2_halfx4 = 300;   % x2 - 0.5*x4 >= 300  <=>  2*x2 - x4 >= 600
int: max_balance = 70;      % x2 - x3 - x1 <= 70

% Variables
var 0..1000: x1;  % resources allocated to unit 1 (integer, non-negative)
var 0..1000: x2;  % resources allocated to unit 2 (integer, non-negative)
var 0..1000: x3;  % resources allocated to unit 3 (integer, non-negative)
var 0..2000: x4;  % resources allocated to unit 4 (integer, non-negative)

% Constraints
% Capacity constraint: combined allocation for units 1 and 2 cannot exceed limit
constraint x1 + x2 <= max_x1_x2;

% Critical mission strength constraint: 2*x1 + x3 must meet minimum requirement
constraint 2 * x1 + x3 >= min_2x1_x3;

% Deployment strategy constraint: x2 - 0.5*x4 >= 300, rewritten to avoid fractions
constraint 2 * x2 - x4 >= 2 * min_x2_halfx4;

% Force balance constraint: x2 - x3 - x1 must not exceed max_balance
constraint x2 - x3 - x1 <= max_balance;

% Objective
solve minimize c1*x1 + c2*x2 + c3*x3 + c4*x4;