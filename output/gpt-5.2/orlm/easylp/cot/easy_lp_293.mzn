% Parameters (with values embedded)
int: cost_X = 5;
int: cost_Y = 3;
int: cost_Z = 1;

int: cap_XY = 30;
int: cap_YZ = 20;
int: min_XZ = 10;

% Variables
var 0..cap_XY: X;
var 0..cap_XY: Y;
var 0..(cap_YZ + min_XZ): Z;

var int: total_cost;

% Constraints
constraint X + Y <= cap_XY;
constraint Y + Z <= cap_YZ;
constraint X + Z >= min_XZ;

constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;