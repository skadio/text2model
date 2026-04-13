% Parameters
int: min_total = 20;
int: max_weighted = 40;
int: cost_x = 50;
int: cost_y = 80;

% Variables
var 0..max_weighted: x; % employees in Project X
var 0..max_weighted: y; % employees in Project Y

% Constraints
constraint x + y >= min_total;
constraint 2*x + y <= max_weighted;

% Objective
solve minimize cost_x * x + cost_y * y;