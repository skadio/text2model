% Parameters
% Cost coefficients for each production line
int: c1 = 20;
int: c2 = 30;
int: c3 = 40;
int: c4 = 50;

% Constraint right-hand sides
int: max_x1_x2 = 200;                 % x1 + x2 <= 200
int: min_2x1_3x3 = 150;               % 2*x1 + 3*x3 >= 150
int: max_halfx4_minus_x1 = 75;        % (x4/2) - x1 <= 75
int: min_x3_halfx4_minus_x2 = 100;    % x3 + (x4/2) - x2 >= 100


% Variables
% Integer resource allocations for the 4 production lines (assume nonnegative allocations)
var 0..1000000: x1;
var 0..1000000: x2;
var 0..1000000: x3;
var 0..1000000: x4;

% Total cost to minimize
var int: total_cost;


% Constraints
% Total cost definition (linking variable to decision variables)
constraint
  total_cost = c1 * x1 + c2 * x2 + c3 * x3 + c4 * x4;

% Budget/capacity: combined allocation on lines 1 and 2 is limited
constraint
  x1 + x2 <= max_x1_x2;

% Minimum production/quality target involving lines 1 and 3
constraint
  2 * x1 + 3 * x3 >= min_2x1_3x3;

% Balance constraint: half of x4 minus x1 is bounded above
% Use 2*() to avoid fractional arithmetic: (x4/2) - x1 <= 75  <=>  x4 - 2*x1 <= 150
constraint
  x4 - 2 * x1 <= 2 * max_halfx4_minus_x1;

% Strategic demand constraint involving x3, x4, and x2
% x3 + (x4/2) - x2 >= 100  <=>  2*x3 + x4 - 2*x2 >= 200
constraint
  2 * x3 + x4 - 2 * x2 >= 2 * min_x3_halfx4_minus_x2;


% Objective
solve minimize total_cost;