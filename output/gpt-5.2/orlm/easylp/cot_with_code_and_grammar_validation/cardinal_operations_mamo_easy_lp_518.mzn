% Parameters
int: total_vehicles = 1000;
int: min_diff_XY = 200;
int: max_abs_diff_YZ = 150;

int: capX = 500;
int: capY = 300;
int: capZ = 200;

int: costX = 10;
int: costY = 20;
int: costZ = 30;

% Variables
var 0..capX: X;
var 0..capY: Y;
var 0..capZ: Z;

var 0..(costX*capX + costY*capY + costZ*capZ): total_cost;

% Constraints
constraint X + Y + Z <= total_vehicles;
constraint X >= Y + min_diff_XY;
constraint abs(Y - Z) <= max_abs_diff_YZ;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;