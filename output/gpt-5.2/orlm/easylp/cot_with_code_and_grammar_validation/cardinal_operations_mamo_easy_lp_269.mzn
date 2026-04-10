% Parameters
int: max_total_hires = 100;
int: min_x = 20;
int: min_y = 30;
int: min_z = 10;

int: salary_x = 50000;
int: salary_y = 70000;
int: salary_z = 90000;

% Variables
var min_x..max_total_hires: X;
var min_y..max_total_hires: Y;
var min_z..max_total_hires: Z;

var 0..(max_total_hires * max(salary_x, max(salary_y, salary_z))): total_cost;

% Constraints
constraint X + Y + Z <= max_total_hires;

constraint total_cost = salary_x * X + salary_y * Y + salary_z * Z;

% Objective
solve minimize total_cost;