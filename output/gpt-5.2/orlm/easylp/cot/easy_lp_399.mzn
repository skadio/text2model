% Parameters (with values embedded)
int: max_XY = 10;
int: max_ZW = 20;
int: min_XZ = 5;
int: min_YW = 7;

int: costX = 1000;
int: costY = 2000;
int: costZ = 500;
int: costW = 1500;

% Variables
var 0..max_XY: X;
var 0..max_XY: Y;
var 0..max_ZW: Z;
var 0..max_ZW: W;

var 0..1000000: total_support;

% Constraints
constraint X + Y <= max_XY;
constraint Z + W <= max_ZW;

constraint X + Z >= min_XZ;
constraint Y + W >= min_YW;

constraint total_support = costX*X + costY*Y + costZ*Z + costW*W;

% Objective
solve minimize total_support;