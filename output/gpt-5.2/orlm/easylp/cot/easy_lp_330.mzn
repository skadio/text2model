% Parameters (with values embedded)
int: maxXY = 100;
int: maxZW = 200;
int: minXZ = 50;
int: minYW = 70;

int: costX = 10;
int: costY = 15;
int: costZ = 25;
int: costW = 30;

% Variables
var 0..maxXY: X;
var 0..maxXY: Y;
var 0..maxZW: Z;
var 0..maxZW: W;

% Constraints
constraint X + Y <= maxXY;
constraint Z + W <= maxZW;

constraint X + Z >= minXZ;
constraint Y + W >= minYW;

% Objective
var int: total_cost = costX*X + costY*Y + costZ*Z + costW*W;
solve minimize total_cost;