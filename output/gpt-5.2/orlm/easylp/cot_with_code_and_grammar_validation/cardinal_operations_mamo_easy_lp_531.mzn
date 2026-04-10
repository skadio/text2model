% Parameters
int: costX = 2;
int: costY = 3;
int: costZ = 1;

int: maxXY = 1000;
int: min2XplusZ = 500;
int: diffYZ = 200;
int: maxXZ = 800;

% Variables
var 0..max(maxXY, maxXZ): X;
var 0..max(maxXY, maxXZ) + diffYZ: Y;
var 0..max(maxXY, maxXZ): Z;

var int: total_cost = costX * X + costY * Y + costZ * Z;

% Constraints
constraint X + Y <= maxXY;
constraint 2 * X + Z >= min2XplusZ;
constraint abs(Y - Z) = diffYZ;
constraint X + Z <= maxXZ;

% Objective
solve minimize total_cost;