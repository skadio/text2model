% Parameters
int: max_xy = 50;
int: min_x = 20;
int: max_y = 30;

float: cX = 1.5;
float: cY = 2.0;
float: cZ = 3.0;
float: cW = 4.0;

% Variables
var 0..max_xy: X;
var 0..max_y: Y;
var 0..max_xy: Z;
var 0..max_xy: W;

var float: total_cost;

% Constraints
constraint X + Y <= max_xy;
constraint X >= min_x;
constraint Y <= max_y;

constraint (Z + W - X) <= 0;

constraint total_cost = cX*X + cY*Y + cZ*Z + cW*W;

% Objective
solve minimize total_cost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), " W=", show(W), "\n",
  "total_cost=", show(total_cost), "\n",
  "rounded_total_cost=", show(round(total_cost)), "\n"
];