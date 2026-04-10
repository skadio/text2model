% Parameters (with values embedded)
int: salary_X = 5000;
int: salary_Y = 8000;
int: max_total_hires = 100;
int: min_hires_X = 20;
int: min_hires_Y = 30;

% Variables
var min_hires_X..max_total_hires: x; % number of hires for position X
var min_hires_Y..max_total_hires: y; % number of hires for position Y
var 0..(salary_X*max_total_hires + salary_Y*max_total_hires): total_cost;

% Constraints
constraint x + y <= max_total_hires;
constraint total_cost = salary_X * x + salary_Y * y;

% Objective
solve minimize total_cost;