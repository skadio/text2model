% Parameters
int: salary_X = 5000;
int: salary_Y = 8000;
int: max_total_hires = 100;
int: min_hires_X = 20;
int: min_hires_Y = 30;

% Variables
var min_hires_X..max_total_hires: hires_X;
var min_hires_Y..max_total_hires: hires_Y;
var 0..(salary_X * max_total_hires + salary_Y * max_total_hires): total_cost;

% Constraints
constraint hires_X + hires_Y <= max_total_hires;
constraint total_cost = salary_X * hires_X + salary_Y * hires_Y;

% Objective
solve minimize total_cost;