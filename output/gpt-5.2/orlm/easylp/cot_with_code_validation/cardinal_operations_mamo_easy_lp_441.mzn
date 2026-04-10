% Parameters
int: costX = 20;
int: costY = 30;
int: maxX = 400;
int: maxY = 300;

int: storageCap = 500;

int: minEffect = 1000;   % 3*X + 2*Y >= 1000

int: maxDiff = 600;      % 4*X - Y <= 600

% Variables
var 0..maxX: x;
var 0..maxY: y;

var 0..(costX*maxX + costY*maxY): total_cost;

% Constraints
constraint x + y <= storageCap;

constraint 3*x + 2*y >= minEffect;

constraint 4*x - y <= maxDiff;

constraint total_cost = costX*x + costY*y;

% Objective
solve minimize total_cost;