% Parameters
int: costX = 5;
int: costY = 8;

int: x_min = 0;
int: x_max = 25;
int: y_min = 0;
int: y_max = 30;

int: cap1 = 50;   % x + 2y <= 50
int: minsum = 10; % x + y >= 10
int: cap3 = 20;   % y - x/2 <= 20  ->  2y - x <= 40

% Variables
var x_min..x_max: x;
var y_min..y_max: y;

% Constraints
constraint x + 2*y <= cap1;
constraint x + y >= minsum;
constraint 2*y - x <= 2*cap3;

% Objective
solve minimize costX*x + costY*y;