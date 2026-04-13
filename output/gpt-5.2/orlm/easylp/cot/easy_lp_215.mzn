% Parameters (with values embedded)
int: costX = 5;
int: costY = 3;
int: costZ = 4;

int: maxX = 500;
int: maxY = 300;
int: maxZ = 200;

int: limitXY = 1000;
int: limitYZ = 800;

int: minDiffXZ = 200;

% Variables
var 0..maxX: X; % purchasing
var 0..maxY: Y; % sales
var 0..maxZ: Z; % logistics

var 0..(costX*maxX + costY*maxY + costZ*maxZ): total_cost;

% Constraints
constraint X + Y <= limitXY;
constraint Y + Z <= limitYZ;
constraint abs(X - Z) >= minDiffXZ;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;