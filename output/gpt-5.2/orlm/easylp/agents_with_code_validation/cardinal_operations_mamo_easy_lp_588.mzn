% Parameters
% Cost coefficients for each production line
int: c1 = 20;
int: c2 = 30;
int: c3 = 40;
int: c4 = 50;

% Constraint right-hand sides / limits
int: cap12  = 200;   % x1 + x2 <= 200
int: min13  = 150;   % 2*x1 + 3*x3 >= 150
int: diff41 = 75;    % (x4/2) - x1 <= 75
int: min342 = 100;   % x3 + (x4/2) - x2 >= 100

% Variable bounds (nonnegative allocations)
int: lb = 0;
int: ub = 1000000;   % safe big-M upper bound

% Variables
var lb..ub: x1;       % integer allocation to production line 1
var lb..ub: x2;       % integer allocation to production line 2
var lb..ub: x3;       % integer allocation to production line 3
var lb..ub: x4;       % integer allocation to production line 4

% Constraints
% --- Budget/capacity constraint on lines 1 and 2 ---
constraint x1 + x2 <= cap12;

% --- Minimum combined production/quality requirement involving lines 1 and 3 ---
constraint 2 * x1 + 3 * x3 >= min13;

% --- Balancing constraint between line 4 (half) and line 1 ---
% Integer-safe form to avoid fractional arithmetic:
% (x4/2) - x1 <= diff41  <=>  x4 - 2*x1 <= 2*diff41
constraint x4 - 2 * x1 <= 2 * diff41;

% --- Strategic priority/demand constraint involving lines 3, 4 (half), and 2 ---
% Integer-safe form:
% x3 + (x4/2) - x2 >= min342  <=>  2*x3 + x4 - 2*x2 >= 2*min342
constraint 2 * x3 + x4 - 2 * x2 >= 2 * min342;

% Objective
solve minimize c1 * x1 + c2 * x2 + c3 * x3 + c4 * x4;