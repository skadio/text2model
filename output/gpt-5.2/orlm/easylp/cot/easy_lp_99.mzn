% Parameters (with values embedded)
int: max_hires = 50;
int: cost_X = 5000;
int: cost_Y = 8000;

% Variables
var 0..max_hires: X;
var 0..max_hires: Y;
var 0..max_hires: notY; % number of allowed hires not used for position Y, i.e., 50 - Y

% Constraints
constraint X + Y <= max_hires;
constraint notY = max_hires - Y;
constraint X >= 3 * notY;

% Objective
var int: total_cost = cost_X * X + cost_Y * Y;
solve minimize total_cost;