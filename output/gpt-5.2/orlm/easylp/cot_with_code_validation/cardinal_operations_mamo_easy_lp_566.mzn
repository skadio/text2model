% Parameters
int: maxX = 1500;
int: maxY = 1300;
int: maxZ = 1200;

int: costX = 50;
int: costY = 60;
int: costZ = 70;

int: XY_max = 2000;
int: XZ_min = 1000;
int: YZ_diff = 500;
int: XY_diff_min = -700;

% Variables
var 0..maxX: X;
var 0..maxY: Y;
var 0..maxZ: Z;

var 0..(costX*maxX + costY*maxY + costZ*maxZ): total_cost;

% Constraints
constraint X + Y <= XY_max;
constraint X + Z >= XZ_min;
constraint Y - Z = YZ_diff;
constraint X - Y >= XY_diff_min;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;