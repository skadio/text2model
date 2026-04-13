% Parameters
int: maxX = 1500;
int: maxY = 1300;
int: maxZ = 1200;

int: costX = 50;
int: costY = 60;
int: costZ = 70;

int: XY_max = 2000;
int: XZ_min = 1000;

int: Y_minus_Z = 500;
int: X_minus_Y_min = -700;

% Variables
var 0..maxX: X;
var 0..maxY: Y;
var 0..maxZ: Z;

var int: total_cost;

% Constraints
constraint X + Y <= XY_max;
constraint X + Z >= XZ_min;

constraint Y - Z = Y_minus_Z;
constraint X - Y >= X_minus_Y_min;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;