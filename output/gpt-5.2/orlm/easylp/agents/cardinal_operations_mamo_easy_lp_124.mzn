% Parameters
int: cost_x = 5;                 % Resource cost per unit allocated to Program X
int: cost_y = 3;                 % Resource cost per unit allocated to Program Y

int: a1_x = 2;                   % Coefficient of X in minimum-support constraint
int: a1_y = 4;                   % Coefficient of Y in minimum-support constraint
int: rhs_min_support = 50;       % Right-hand side for minimum-support constraint (>=)

int: a2_x = 3;                   % Coefficient of X in capacity constraint
int: a2_y = 1;                   % Coefficient of Y in capacity constraint
int: rhs_capacity = 30;          % Right-hand side for capacity constraint (<=)

% Safe variable bounds derived from the capacity constraint and non-negativity:
% From 3x + y <= 30 with x,y >= 0:
%   x <= 30 div 3 = 10
%   y <= 30
int: x_ub = rhs_capacity div a2_x;  % 10
int: y_ub = rhs_capacity;          % 30

% Variables
var 0..x_ub: x;                  % Whole-number resources allocated to Program X
var 0..y_ub: y;                  % Whole-number resources allocated to Program Y

var 0..(cost_x * x_ub + cost_y * y_ub): total_cost;  % Total resource expenditure

% Constraints
% Minimum-support requirement: ensure sufficient combined support for both programs
constraint a1_x * x + a1_y * y >= rhs_min_support;

% Capacity limitation: do not exceed the available resource limit
constraint a2_x * x + a2_y * y <= rhs_capacity;

% Accounting constraint: compute total resource expenditure from allocations
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;