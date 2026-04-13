% Parameters
int: cX = 8;
int: cY = 12;

int: a1X = 2;
int: a1Y = 3;
int: b1 = 40;

int: a2X = 4;
int: a2Y = 1;
int: b2 = 30;

% Upper bounds derived from constraints to keep variables bounded
int: maxX = min(b1 div a1X, b2 div a2X + b1); % safe finite bound
int: maxY = b1 div a1Y;

% Variables
var 0..maxX: x;
var 0..maxY: y;
var 0..(cX*maxX + cY*maxY): total_cost;

% Constraints
constraint a1X * x + a1Y * y <= b1;
constraint a2X * x + a2Y * y >= b2;

constraint total_cost = cX * x + cY * y;

% Objective
solve minimize total_cost;