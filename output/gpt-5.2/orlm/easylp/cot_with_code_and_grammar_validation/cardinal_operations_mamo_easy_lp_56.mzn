% Parameters
int: total_space = 2000;
int: demand_min = 500;
int: balance_max = 1000;

int: costX = 2;
int: costY = 3;

% Variables
var 0..total_space: X;
var 0..total_space: Y;

% Constraints
constraint X + Y <= total_space;
constraint 2 * X + Y >= demand_min;
constraint abs(X - 2 * Y) <= balance_max;

% Objective
solve minimize costX * X + costY * Y;