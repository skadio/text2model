% Parameters
int: costX = 20;
int: costY = 30;
int: min_effect = 10;
int: max_capacity = 50;

% Variables
var 0..50: x; % units of Project X
var 0..10: y; % units of Project Y (since x + 5y <= 50)

% Constraints
constraint 3 * x + y >= min_effect;
constraint x + 5 * y <= max_capacity;

% Objective
solve minimize costX * x + costY * y;