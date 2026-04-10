% Parameters
% Cost coefficients (units per resource unit)
int: c1 = 4;
int: c2 = 3;
int: c3 = 5;
int: c4 = 6;

% Upper bounds on allocations
int: ub1 = 300;
int: ub2 = 500;
int: ub3 = 2000;
int: ub4 = 30;

% Constraint right-hand sides
int: rhs12_max   = 1000;  % x1 + x2 <= 1000
int: rhs13_min   = 2000;  % 2*x1 + 3*x3 >= 2000
int: rhs24_diff  = 500;   % x2 - 0.5*x4 <= 500
int: rhs123_diff = 70;    % x1 - (x2 + x3) <= 70

% Variables
% Integer allocations (whole units of resources)
var 0..ub1: x1;   % resources allocated to project 1
var 0..ub2: x2;   % resources allocated to project 2
var 0..ub3: x3;   % resources allocated to project 3
var 0..ub4: x4;   % resources allocated to project 4

% Constraints

% --- Budget / combined allocation limit ---
constraint x1 + x2 <= rhs12_max;

% --- Minimum requirement involving x1 and x3 ---
constraint 2 * x1 + 3 * x3 >= rhs13_min;

% --- Difference constraint between x2 and half of x4 (avoid float by multiplying by 2) ---
% x2 - 0.5*x4 <= rhs24_diff  <=>  2*x2 - x4 <= 2*rhs24_diff
constraint 2 * x2 - x4 <= 2 * rhs24_diff;

% --- Difference constraint between x1 and (x2 + x3) ---
constraint x1 - (x2 + x3) <= rhs123_diff;

% Objective
solve minimize c1 * x1 + c2 * x2 + c3 * x3 + c4 * x4;