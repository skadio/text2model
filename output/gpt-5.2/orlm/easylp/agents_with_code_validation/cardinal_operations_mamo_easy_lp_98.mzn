% Parameters
int: total_budget = 50000;                 % Maximum total training budget (dollars)
int: min_strategic_margin = 10000;         % Required: 3*alloc_X - alloc_Y >= this (dollars)

int: cost_per_employee_X = 5000;           % Training cost per employee in group X (dollars)
int: cost_per_employee_Y = 7000;           % Training cost per employee in group Y (dollars)

int: max_employees_X = 40;                 % Capacity limit for group X trainees
int: max_employees_Y = 20;                 % Capacity limit for group Y trainees

% Variables
var 0..max_employees_X: x_employees;       % Number of employees trained in group X
var 0..max_employees_Y: y_employees;       % Number of employees trained in group Y

var 0..(max_employees_X*cost_per_employee_X): alloc_X;  % Dollars allocated to group X
var 0..(max_employees_Y*cost_per_employee_Y): alloc_Y;  % Dollars allocated to group Y

var 0..total_budget: total_cost;           % Total training cost (dollars)

% Constraints

% Link allocations to number of employees trained (cost per employee)
constraint alloc_X = x_employees * cost_per_employee_X;
constraint alloc_Y = y_employees * cost_per_employee_Y;

% Total cost definition
constraint total_cost = alloc_X + alloc_Y;

% Budget feasibility: total allocation cannot exceed available budget
constraint total_cost <= total_budget;

% Strategic objective: 3*alloc_X - alloc_Y must be at least the required margin
constraint 3 * alloc_X - alloc_Y >= min_strategic_margin;

% Objective
solve minimize total_cost;