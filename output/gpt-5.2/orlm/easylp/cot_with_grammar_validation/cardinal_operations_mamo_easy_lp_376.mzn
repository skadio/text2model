% Parameters
int: max_XY = 50;
int: min_X = 20;
int: max_Y = 30;

float: cost_X = 1.5;
float: cost_Y = 2.0;
float: cost_Z = 3.0;
float: cost_W = 4.0;

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

constraint total_cost = cost_X * int2float(X)
                      + cost_Y * int2float(Y)
                      + cost_Z * int2float(Z)
                      + cost_W * int2float(W);

% Objective
solve minimize total_cost;