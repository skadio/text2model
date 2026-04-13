% Parameters
int: max_total_allocation = 100;          % Total allocation upper limit
int: ub_x1 = 20;                          % Upper bound for x1
int: ub_x2 = 30;                          % Upper bound for x2
int: ub_x3 = 40;                          % Upper bound for x3
int: ub_x4 = 50;                          % Upper bound for x4

int: cost_x1 = 200;                       % Cost per unit for x1
int: cost_x2 = 300;                       % Cost per unit for x2
int: cost_x3 = 500;                       % Cost per unit for x3
int: cost_x4 = 1000;                      % Cost per unit for x4


% Variables
var 0..ub_x1: x1;                         % Allocation to department 1
var 0..ub_x2: x2;                         % Allocation to department 2
var 0..ub_x3: x3;                         % Allocation to department 3
var 0..ub_x4: x4;                         % Allocation to department 4

% Total cost upper bound based on variable upper bounds
var 0..(cost_x1*ub_x1 + cost_x2*ub_x2 + cost_x3*ub_x3 + cost_x4*ub_x4): total_cost;


% Constraints
% Total allocation limit across all departments
constraint x1 + x2 + x3 + x4 <= max_total_allocation;

% Minimum research funding requirement
constraint 10 * x1 + 20 * x2 >= 50;

% Strategic relationship between departments 3 and 4
constraint 3 * x3 <= 40 * x4 + 10;

% Faculty salaries and operating expenses constraint (scaled to keep integer-linear)
% Original: 15.5*x2 - 0.5*x3 - x1 <= 70
% Scaled by 2: 31*x2 - x3 - 2*x1 <= 140
constraint 31 * x2 - x3 - 2 * x1 <= 140;

% Define total cost from per-department unit costs
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;


% Objective
solve minimize total_cost;