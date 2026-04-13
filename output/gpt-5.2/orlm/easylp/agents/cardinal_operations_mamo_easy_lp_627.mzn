% Parameters
int: cost_x1 = 5000; % cost per employee in department X1
int: cost_x2 = 4000; % cost per employee in department X2
int: cost_x3 = 6000; % cost per employee in department X3
int: cost_x4 = 7000; % cost per employee in department X4

int: min_x1_x2 = 10; % minimum combined employees in X1 and X2
int: max_x3_x4 = 20; % maximum combined employees in X3 and X4

int: rhs_diff_1 = 5; % RHS for constraint: 2*X2 - X1 - X3 >= 5
int: rhs_diff_2 = 5; % RHS for constraint: X4 - X1 - X2 >= 5

int: ub_x1 = 30; % upper bound for employees in X1
int: ub_x2 = 40; % upper bound for employees in X2
int: ub_x3 = 50; % upper bound for employees in X3
int: ub_x4 = 60; % upper bound for employees in X4

% Variables
var 0..ub_x1: x1; % number of employees in department X1
var 0..ub_x2: x2; % number of employees in department X2
var 0..ub_x3: x3; % number of employees in department X3
var 0..ub_x4: x4; % number of employees in department X4

var int: total_cost; % total staffing cost (to be minimized)

% Constraints
% Link total cost to staffing levels and per-department costs
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

% Minimum combined staffing requirement for departments X1 and X2
constraint x1 + x2 >= min_x1_x2;

% Maximum combined staffing limit for departments X3 and X4
constraint x3 + x4 <= max_x3_x4;

% Difference constraint: 2*X2 - X1 - X3 must be at least rhs_diff_1
constraint 2 * x2 - x1 - x3 >= rhs_diff_1;

% Difference constraint: X4 - X1 - X2 must be at least rhs_diff_2
constraint x4 - x1 - x2 >= rhs_diff_2;

% Objective
solve minimize total_cost;