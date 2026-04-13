% Parameters
int: max_XY = 5000;
int: max_ZW = 2000;

int: min_X_minus_Z = 1000;
int: min_Y_minus_W = 1500;

int: max_X = 4000;
int: max_Y = 3000;
int: min_Z = 500;
int: min_W = 200;

int: cX = 20;
int: cY = 30;
int: cZ = 50;
int: cW = 10;

% Variables
var 0..max_X: X;
var 0..max_Y: Y;
var min_Z..(max_ZW - min_W): Z;
var min_W..(max_ZW - min_Z): W;

var int: total_cost;

% Constraints
constraint X + Y <= max_XY;
constraint Z + W <= max_ZW;

constraint X - Z >= min_X_minus_Z;
constraint Y - W >= min_Y_minus_W;

constraint total_cost = cX*X + cY*Y + cZ*Z + cW*W;

% Objective
solve minimize total_cost;