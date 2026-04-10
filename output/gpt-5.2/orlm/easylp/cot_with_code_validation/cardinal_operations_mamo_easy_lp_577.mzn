% Parameters
int: maxX = 100;
int: maxY = 120;
int: maxZ = 90;

int: limitXY = 200;
int: minYZ = 150;
int: diffXZ = 30;

int: costX = 5;
int: costY = 4;
int: costZ = 3;

% Variables
var 0..maxX: X;
var 0..maxY: Y;
var 0..maxZ: Z;

var 0..(costX*maxX + costY*maxY + costZ*maxZ): total_cost;

% Constraints
constraint X + Y <= limitXY;
constraint Y + Z >= minYZ;
constraint X - Z = diffXZ;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;