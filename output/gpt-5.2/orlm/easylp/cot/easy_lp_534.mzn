% Parameters (with values embedded)
int: max_XY = 1000;
int: max_YZ = 800;
int: min_XZ = 500;
int: max_diff_XY = 200;

int: cost_X = 20;
int: cost_Y = 30;
int: cost_Z = 10;

% Variables
var 0..1000: X;
var 0..1000: Y;
var 0..800:  Z;

var int: total_cost;

% Constraints
constraint X + Y <= max_XY;
constraint Y + Z <= max_YZ;
constraint X + Z >= min_XZ;
constraint abs(X - Y) <= max_diff_XY;

constraint total_cost = cost_X * X + cost_Y * Y + cost_Z * Z;

% Objective
solve minimize total_cost;