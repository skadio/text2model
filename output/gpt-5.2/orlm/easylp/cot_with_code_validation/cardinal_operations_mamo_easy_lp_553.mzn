% Parameters
int: max_total = 100;
int: min_x = 30;
int: min_y = 20;
int: min_z = 10;

int: salary_x = 5000;
int: salary_y = 4000;
int: salary_z = 6000;

% Variables
var min_x..max_total: x;
var min_y..max_total: y;
var min_z..max_total: z;

var 0..(max_total * max([salary_x, salary_y, salary_z])): total_cost;

% Constraints
constraint x + y + z <= max_total;

constraint total_cost = salary_x * x + salary_y * y + salary_z * z;

% Objective
solve minimize total_cost;