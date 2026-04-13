% Parameters
int: max_total_hires = 100;
int: min_x = 30;
int: min_y = 20;
int: min_z = 10;

int: salary_x = 5000;
int: salary_y = 4000;
int: salary_z = 6000;

% Variables
var 0..max_total_hires: x;
var 0..max_total_hires: y;
var 0..max_total_hires: z;

var 0..(max_total_hires * max(salary_x, max(salary_y, salary_z))): total_cost;

% Constraints
constraint x >= min_x;
constraint y >= min_y;
constraint z >= min_z;

constraint x + y + z <= max_total_hires;

constraint total_cost = salary_x * x + salary_y * y + salary_z * z;

% Objective
solve minimize total_cost;