% Parameters (with values embedded)
int: costX = 4;
int: costY = 3;
int: costZ = 2;

int: maxXY = 25;
int: minXZ = 15;
int: maxYZ = 20;

% Variables
var 0..25: X;  % Math teachers
var 0..25: Y;  % Science teachers
var 0..20: Z;  % Arts teachers

var 0..(costX*25 + costY*25 + costZ*20): total_cost;

% Constraints
constraint X + Y <= maxXY;
constraint X + Z >= minXZ;
constraint Y + Z <= maxYZ;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;