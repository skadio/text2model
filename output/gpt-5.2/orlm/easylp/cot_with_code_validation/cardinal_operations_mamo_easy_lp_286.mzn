% Parameters
int: costX = 10;
int: costY = 15;
int: costZ = 20;

int: maxXY = 100;
int: maxYZ = 150;
int: minXZ = 50;

int: ubX = maxXY;                      % from X + Y <= maxXY and Y >= 0
int: ubY = min(maxXY, maxYZ);          % from X + Y <= maxXY and Y + Z <= maxYZ
int: ubZ = maxYZ;                      % from Y + Z <= maxYZ and Y >= 0

% Variables
var 0..ubX: x;
var 0..ubY: y;
var 0..ubZ: z;

var 0..(costX*ubX + costY*ubY + costZ*ubZ): total_cost;

% Constraints
constraint x + y <= maxXY;
constraint y + z <= maxYZ;
constraint x + z >= minXZ;

constraint total_cost = costX * x + costY * y + costZ * z;

% Objective
solve minimize total_cost;