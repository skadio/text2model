% Parameters (with values embedded)
int: costX = 5;
int: costY = 8;

int: maxResX = 25;
int: maxResY = 30;

int: cap1 = 50;   % X + 2Y <= 50
int: minSum = 10; % X + Y >= 10
int: cap3 = 20;   % Y - X/2 <= 20  <=>  2Y - X <= 40

% Variables
var 0..maxResX: x; % resource allocation for project X (integer)
var 0..maxResY: y; % resource allocation for project Y (integer)

% Constraints
constraint x + 2*y <= cap1;
constraint x + y >= minSum;
constraint 2*y - x <= 2*cap3;

% Objective
solve minimize costX * x + costY * y;