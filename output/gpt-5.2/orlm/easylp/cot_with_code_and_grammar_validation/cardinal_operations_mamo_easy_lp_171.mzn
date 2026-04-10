% Parameters
int: max_XY = 1000;
int: max_YZ = 800;
int: min_XZ = 500;

int: roi_X = 2;
int: roi_Y = 3;
int: roi_Z = 5;

% Variables
var 0..max_XY: x;
var 0..max_XY: y;
var 0..max_YZ: z;

var 0..(max_XY + max_YZ): total_cost;

% Constraints
constraint x + y <= max_XY;
constraint y + z <= max_YZ;
constraint x + z >= min_XZ;

constraint total_cost = x + y + z;

% Objective
solve minimize total_cost;