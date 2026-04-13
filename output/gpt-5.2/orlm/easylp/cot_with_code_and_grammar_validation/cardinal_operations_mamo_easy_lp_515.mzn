% Parameters
int: costX = 10;
int: costY = 15;
int: costZ = 20;

int: capX = 700;
int: capY = 600;
int: capZ = 400;

int: maxXY = 1000;
int: maxYZ = 800;
int: minXZ = 500;

% Variables
var 0..capX: x;
var 0..capY: y;
var 0..capZ: z;

var 0..(costX*capX + costY*capY + costZ*capZ): total_cost;

% Constraints
constraint x + y <= maxXY;
constraint y + z <= maxYZ;
constraint x + z >= minXZ;

constraint total_cost = costX * x + costY * y + costZ * z;

% Objective
solve minimize total_cost;