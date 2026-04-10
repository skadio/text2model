% Parameters
int: salary_X = 5000;
int: salary_Y = 3000;
int: max_total_hires = 50;
int: min_X = 20;
int: max_Y = 15;

% Variables
var 0..max_total_hires: X;
var 0..max_total_hires: Y;
var 0..(salary_X * max_total_hires + salary_Y * max_total_hires): total_cost;

% Constraints
constraint X + Y <= max_total_hires;
constraint X >= min_X;
constraint Y <= max_Y;

constraint total_cost = salary_X * X + salary_Y * Y;

% Objective
solve minimize total_cost;