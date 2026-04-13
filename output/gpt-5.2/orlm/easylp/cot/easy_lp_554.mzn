% Parameters (with values embedded)
int: max_total_employees = 100;
int: min_X = 20;
int: min_Y = 30;
int: min_Z = 10;

int: cost_X = 5000;
int: cost_Y = 4000;
int: cost_Z = 6000;

% Variables
var 0..max_total_employees: employees_X;
var 0..max_total_employees: employees_Y;
var 0..max_total_employees: employees_Z;

var 0..(max_total_employees * max([cost_X, cost_Y, cost_Z])): total_cost;

% Constraints
constraint employees_X >= min_X;
constraint employees_Y >= min_Y;
constraint employees_Z >= min_Z;

constraint employees_X + employees_Y + employees_Z <= max_total_employees;

constraint total_cost = cost_X * employees_X + cost_Y * employees_Y + cost_Z * employees_Z;

% Objective
solve minimize total_cost;

output [
  "employees_X = ", show(employees_X), "\n",
  "employees_Y = ", show(employees_Y), "\n",
  "employees_Z = ", show(employees_Z), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];