% Parameters
int: costX = 2;
int: costY = 3;
int: costZ = 4;

int: maxXY = 100;
int: maxYZ = 150;
int: minXZ = 80;

% Variables
var 0..maxXY: x;                 % vehicles on route X
var 0..max(maxYZ, maxXY): y;      % vehicles on route Y
var 0..maxYZ: z;                 % vehicles on route Z

var int: total_cost;

% Constraints
constraint x + y <= maxXY;
constraint y + z <= maxYZ;
constraint x + z >= minXZ;

constraint total_cost = costX * x + costY * y + costZ * z;

% Objective
solve minimize total_cost;