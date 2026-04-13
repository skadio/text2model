% Parameters
int: maxXY = 100;
int: maxZW = 80;
int: minXZ = 50;
int: minYW = 60;

float: cX = 0.2;
float: cY = 0.3;
float: cZ = 0.1;
float: cW = 0.4;

% Variables
var 0..maxXY: X;
var 0..maxXY: Y;
var 0..maxZW: Z;
var 0..maxZW: W;

var float: total_cost;

% Constraints
constraint X + Y <= maxXY;
constraint Z + W <= maxZW;

constraint X + Z >= minXZ;
constraint Y + W >= minYW;

constraint total_cost = cX*int2float(X) + cY*int2float(Y) + cZ*int2float(Z) + cW*int2float(W);

% Objective
solve minimize total_cost;