% Parameters
int: max_total_shifts = 24;
int: costX = 8;
int: costY = 6;
int: costZ = 10;

int: maxX = 12;
int: maxY = 8;
int: maxZ = 6;

int: yz_diff_max = 4;
int: x_minus_y_min = 2;

% Variables
var 0..maxX: X;
var 0..maxY: Y;
var 0..maxZ: Z;

var 0..(costX*maxX + costY*maxY + costZ*maxZ): total_cost;

% Constraints
constraint X + Y + Z <= max_total_shifts;

constraint X >= Y + x_minus_y_min;

constraint abs(Y - Z) <= yz_diff_max;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;