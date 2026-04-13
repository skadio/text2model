% Parameters (with values embedded)
int: costX = 5;
int: costY = 4;
int: costZ = 3;

int: maxXY = 20;
int: minYZ = 30;
int: maxDiffXZ = 10;

% Variables
var 0..100: x; % packages to region X
var 0..100: y; % packages to region Y
var 0..100: z; % packages to region Z

var 0..10000: total_cost;

% Constraints
constraint x + y <= maxXY;
constraint y + z >= minYZ;
constraint abs(x - z) <= maxDiffXZ;

constraint total_cost = costX * x + costY * y + costZ * z;

% Objective
solve minimize total_cost;