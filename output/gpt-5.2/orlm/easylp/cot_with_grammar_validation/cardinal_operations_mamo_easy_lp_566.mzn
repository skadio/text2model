% Parameters
int: maxX = 1500;
int: maxY = 1300;
int: maxZ = 1200;

int: cX = 50;
int: cY = 60;
int: cZ = 70;

% Variables
var 0..maxX: X;
var 0..maxY: Y;
var 0..maxZ: Z;

var int: total_cost;

% Constraints
constraint X + Y <= 2000;
constraint X + Z >= 1000;
constraint Y - Z = 500;
constraint X - Y >= -700;

constraint total_cost = cX * X + cY * Y + cZ * Z;

% Objective
solve minimize total_cost;