% Parameters
int: costX = 20;
int: costY = 30;

int: maxTotal = 500;
int: minEffect = 1000;

int: maxX = 400;
int: maxY = 300;

int: rhsDiff = 600;

% Variables
var 0..maxX: x;
var 0..maxY: y;

% Constraints
constraint x + y <= maxTotal;

constraint 3 * x + 2 * y >= minEffect;

constraint 4 * x - y <= rhsDiff;

% Objective
solve minimize costX * x + costY * y;