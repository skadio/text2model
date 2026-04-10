% Parameters
% Resource limit and minimum staffing requirements (embedded from problem statement)
int: max_total_employees = 100;
int: min_employees_X = 40;
int: min_employees_Y = 20;

% Cost per employee (in dollars)
int: cost_per_employee_X = 50;
int: cost_per_employee_Y = 30;

% Variables
% Number of employees allocated to each project (integers, non-negative, bounded)
var 0..max_total_employees: employees_X;
var 0..max_total_employees: employees_Y;

% Total cost (bounded using max_total_employees and max unit cost)
var 0..(max_total_employees * max(cost_per_employee_X, cost_per_employee_Y)): total_cost;

% Constraints
% Staffing requirements: ensure minimum employees assigned to each project
constraint employees_X >= min_employees_X;
constraint employees_Y >= min_employees_Y;

% Resource limit: total employees across both projects cannot exceed the maximum available
constraint employees_X + employees_Y <= max_total_employees;

% Total cost definition: compute total_cost from employee allocations and per-employee costs
constraint total_cost = cost_per_employee_X * employees_X + cost_per_employee_Y * employees_Y;

% Objective
solve minimize total_cost;

% (Optional) Output for clarity
output [
  "employees_X=", show(employees_X), "\n",
  "employees_Y=", show(employees_Y), "\n",
  "total_cost=", show(total_cost), "\n"
];