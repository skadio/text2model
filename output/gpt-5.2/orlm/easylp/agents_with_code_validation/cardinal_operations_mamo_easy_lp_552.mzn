% Parameters
int: max_total_employees = 10;          % Cap on total employees across all departments

int: min_x1 = 2;                       % Minimum employees required in department X1
int: min_x2 = 3;                       % Minimum employees required in department X2
int: min_x3 = 5;                       % Minimum employees required in department X3

int: lb_x1 = 0; int: ub_x1 = 6;        % Staffing bounds for X1
int: lb_x2 = 0; int: ub_x2 = 4;        % Staffing bounds for X2
int: lb_x3 = 0; int: ub_x3 = 5;        % Staffing bounds for X3

int: cost_x1 = 50000;                  % Cost per employee in X1 (USD)
int: cost_x2 = 60000;                  % Cost per employee in X2 (USD)
int: cost_x3 = 70000;                  % Cost per employee in X3 (USD)

% Variables
var lb_x1..ub_x1: x1;                  % Employees in department X1
var lb_x2..ub_x2: x2;                  % Employees in department X2
var lb_x3..ub_x3: x3;                  % Employees in department X3

var 0..(ub_x1*cost_x1 + ub_x2*cost_x2 + ub_x3*cost_x3): total_cost;  % Total cost (USD)

% Constraints
% Minimum staffing requirements per department
constraint x1 >= min_x1;
constraint x2 >= min_x2;
constraint x3 >= min_x3;

% Total headcount constraint
constraint x1 + x2 + x3 <= max_total_employees;

% Total cost definition
constraint total_cost = x1 * cost_x1 + x2 * cost_x2 + x3 * cost_x3;

% Objective
solve minimize total_cost;

% Optional output
output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "total_cost = ", show(total_cost), "\n"
];