% Parameters (with values embedded)
int: budget = 1000;
int: costX = 4;
int: costY = 3;
int: extra = 300;

% Variables
var 0..budget: x;  % resources allocated to campaign X
var 0..budget: y;  % resources allocated to campaign Y

% Constraints
constraint x + y <= budget;
constraint x >= 2 * y + extra;

% Objective
solve minimize costX * x + costY * y;