% Parameters
int: maxXY = 100;
int: maxZW = 80;
int: minXZ = 50;
int: minYW = 60;

% Use scaled integer costs to avoid floating-point: multiply all costs by 10
int: scale = 10;
int: cX = 2;  % 0.2 * 10
int: cY = 3;  % 0.3 * 10
int: cZ = 1;  % 0.1 * 10
int: cW = 4;  % 0.4 * 10

% Variables
var 0..maxXY: X;
var 0..maxXY: Y;
var 0..maxZW: Z;
var 0..maxZW: W;

var 0..(cX*maxXY + cY*maxXY + cZ*maxZW + cW*maxZW): totalCostScaled;

% Constraints
constraint X + Y <= maxXY;
constraint Z + W <= maxZW;

constraint X + Z >= minXZ;
constraint Y + W >= minYW;

constraint totalCostScaled = cX*X + cY*Y + cZ*Z + cW*W;

% Objective
solve minimize totalCostScaled;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), " W=", show(W), "\n",
  "min_total_cost_rounded_up=", show((totalCostScaled + scale - 1) div scale), "\n"
];