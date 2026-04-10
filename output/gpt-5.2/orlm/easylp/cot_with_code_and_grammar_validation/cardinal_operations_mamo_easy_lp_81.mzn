% Parameters
int: req_min = 200;          % 2*X + 3*Y >= req_min
int: balance_max = 300;      % 4*X + 1*Y <= balance_max
int: maxX = 100;
int: maxY = 80;
int: costX = 500;
int: costY = 600;

% Variables
var 0..maxX: X;
var 0..maxY: Y;
var 0..(costX*maxX + costY*maxY): total_cost;

% Constraints
constraint 2*X + 3*Y >= req_min;
constraint 4*X + Y <= balance_max;
constraint X >= Y;

constraint total_cost = costX*X + costY*Y;

% Objective
solve minimize total_cost;