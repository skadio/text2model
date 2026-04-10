% Parameters
int: salary_X = 5000;
int: salary_Y = 8000;

int: max_total_hires = 100;
int: min_hires_X = 20;
int: min_hires_Y = 30;

% Variables
var 0..max_total_hires: x; % hires for position X
var 0..max_total_hires: y; % hires for position Y
var 0..(max_total_hires * max(salary_X, salary_Y)): total_cost;

% Constraints
constraint x + y <= max_total_hires;
constraint x >= min_hires_X;
constraint y >= min_hires_Y;

constraint total_cost = salary_X * x + salary_Y * y;

% Objective
solve minimize total_cost;