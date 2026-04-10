% Parameters (with values embedded)
int: costX = 5000;
int: costY = 3000;
int: capacity = 1000;
int: demand = 2000;
int: min_diff = 150;

% Variables
var 0..capacity: X;
var 0..capacity: Y;

% Constraints
constraint X + Y <= capacity;
constraint 3 * X + 2 * Y >= demand;
constraint X - Y >= min_diff;

% Objective
solve minimize costX * X + costY * Y;