% Parameters
int: max_total_hires = 100;
int: min_X = 20;
int: min_Y = 30;
int: min_Z = 10;

int: salary_X = 50000;
int: salary_Y = 70000;
int: salary_Z = 90000;

% Variables
var min_X..max_total_hires: X;
var min_Y..max_total_hires: Y;
var min_Z..max_total_hires: Z;

var 0..(max_total_hires * max(salary_X, max(salary_Y, salary_Z))): total_cost;

% Constraints
constraint X + Y + Z <= max_total_hires;

constraint total_cost = salary_X * X + salary_Y * Y + salary_Z * Z;

% Objective
solve minimize total_cost;