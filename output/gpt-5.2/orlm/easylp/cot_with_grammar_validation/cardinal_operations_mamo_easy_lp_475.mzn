% Parameters
int: max_total = 50;
int: min_total = 10;
int: x_coef = 100;
int: y_coef = 150;
int: balance_const = 20;

% Variables
var 0..max_total: x;
var 0..max_total: y;
var 0..(x_coef*max_total + y_coef*max_total): total_resources;

% Constraints
constraint x + y <= max_total;
constraint x + y >= min_total;
constraint x <= 2*y + balance_const;

constraint total_resources = x_coef*x + y_coef*y;

% Objective
solve minimize total_resources;