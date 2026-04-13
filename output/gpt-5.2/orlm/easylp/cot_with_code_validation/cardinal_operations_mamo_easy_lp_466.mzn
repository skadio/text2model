% Parameters
int: salary_X = 5000;
int: salary_Y = 3000;
int: max_total_hires = 50;
int: min_X = 20;
int: max_Y = 15;

% Variables
var 0..max_total_hires: x;
var 0..max_total_hires: y;
var 0..(salary_X*max_total_hires + salary_Y*max_total_hires): total_cost;

% Constraints
constraint x + y <= max_total_hires;
constraint x >= min_X;
constraint y <= max_Y;
constraint total_cost = salary_X * x + salary_Y * y;

% Objective
solve minimize total_cost;