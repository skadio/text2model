% Parameters
int: TOTAL_MAX = 5000;
int: XY_MIN = 2000;
int: YZ_MAX = 2500;

int: costX = 50;
int: costY = 30;
int: costZ = 20;

% Variables
var 0..TOTAL_MAX: x;
var 0..TOTAL_MAX: y;
var 0..TOTAL_MAX: z;

var 0..(costX*TOTAL_MAX + costY*TOTAL_MAX + costZ*TOTAL_MAX): total_cost;

% Constraints
constraint x + y + z <= TOTAL_MAX;

constraint x + y >= XY_MIN;
constraint 2 * x = y;

constraint y + z <= YZ_MAX;

constraint total_cost = costX * x + costY * y + costZ * z;

% Objective
solve minimize total_cost;