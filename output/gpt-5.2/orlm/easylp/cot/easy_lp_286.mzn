% Parameters (with values embedded)
int: costX = 10;
int: costY = 15;
int: costZ = 20;

int: maxXY = 100;
int: maxYZ = 150;
int: minXZ = 50;

% Variables
var 0..maxXY: X;        % bounded by X+Y <= 100 with Y>=0
var 0..maxXY: Y;        % bounded by X+Y <= 100 with X>=0
var 0..maxYZ: Z;        % bounded by Y+Z <= 150 with Y>=0

var 0..(costX*maxXY + costY*maxXY + costZ*maxYZ): total_cost;

% Constraints
constraint X + Y <= maxXY;
constraint Y + Z <= maxYZ;
constraint X + Z >= minXZ;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;