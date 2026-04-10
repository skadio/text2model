% Parameters
int: demand = 50;
int: limit = 120;
int: costX = 7;
int: costY = 5;

% Variables
var 0..limit: x; % number of ships X
var 0..limit: y; % number of ships Y

% Constraints
constraint x + y >= demand;
constraint 2 * x + y <= limit;

% Objective
solve minimize costX * x + costY * y;