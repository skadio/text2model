% Parameters
int: max_budget = 2000;
int: diff_min = 500;
int: costX = 50;
int: costY = 100;

% Variables
var 0..max_budget: x; % integer budget units for channel X
var 0..max_budget: y; % integer budget units for channel Y

% Constraints
constraint x + y <= max_budget;
constraint 3 * x - 2 * y >= diff_min;

% Objective
solve minimize costX * x + costY * y;