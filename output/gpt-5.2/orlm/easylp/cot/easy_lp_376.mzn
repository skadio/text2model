% Parameters (with values embedded)
int: max_XY = 50;
int: min_X = 20;
int: max_Y = 30;

float: costX = 1.5;
float: costY = 2.0;
float: costZ = 3.0;
float: costW = 4.0;

% Variables
var 0..max_XY: X;
var 0..max_Y: Y;
var 0..max_XY: Z;
var 0..max_XY: W;

% Constraints
constraint X + Y <= max_XY;
constraint X >= min_X;
constraint Y <= max_Y;
constraint Z + W - X <= 0;

% Objective
var float: total_cost = costX*int2float(X) + costY*int2float(Y) + costZ*int2float(Z) + costW*int2float(W);
solve minimize total_cost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), " W=", show(W), "\n",
  "total_cost=", show(total_cost), "\n",
  "rounded_total_cost=", show(round(total_cost)), "\n"
];