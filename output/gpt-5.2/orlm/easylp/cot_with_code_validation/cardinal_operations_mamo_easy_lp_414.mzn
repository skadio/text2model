% Parameters
int: max_total_budget = 5000;
int: min_diff_2x_minus_y = 1000;
int: max_diff_x_minus_3y = 2000;

int: cost_x = 1000;
int: cost_y = 1500;

% Variables
var 0..max_total_budget: x; % dollars allocated to channel X
var 0..max_total_budget: y; % dollars allocated to channel Y

var 0..(cost_x*max_total_budget + cost_y*max_total_budget): total_expenditure;

% Constraints
constraint x + y <= max_total_budget;
constraint 2*x - y >= min_diff_2x_minus_y;
constraint x - 3*y <= max_diff_x_minus_3y;

constraint total_expenditure = cost_x * x + cost_y * y;

% Objective
solve minimize total_expenditure;