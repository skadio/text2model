% Parameters
int: max_XY = 50;
int: min_X = 20;
int: max_Y = 30;

float: cX = 1.5;
float: cY = 2.0;
float: cZ = 3.0;
float: cW = 4.0;

% Variables
var 0..max_XY: X;
var 0..max_Y: Y;
var 0..max_XY: Z;
var 0..max_XY: W;

var float: total_cost;

% Constraints
constraint X + Y <= max_XY;
constraint X >= min_X;
constraint Y <= max_Y;

constraint Z + W - X <= 0;

constraint total_cost = cX*int2float(X) + cY*int2float(Y) + cZ*int2float(Z) + cW*int2float(W);

% Objective
solve minimize total_cost;