% Parameters (with values embedded)
int: max_XY = 100;
int: max_ZW = 80;
int: min_XZ = 50;
int: min_YW = 60;

% Costs per unit (represented as integers by scaling by 10)
int: scale = 10;
int: cX = 2;  % 0.2 * 10
int: cY = 3;  % 0.3 * 10
int: cZ = 1;  % 0.1 * 10
int: cW = 4;  % 0.4 * 10

% Variables
var 0..max_XY: X;
var 0..max_XY: Y;
var 0..max_ZW: Z;
var 0..max_ZW: W;

var 0..(cX*max_XY + cY*max_XY + cZ*max_ZW + cW*max_ZW): totalCostScaled;

% Constraints
constraint X + Y <= max_XY;
constraint Z + W <= max_ZW;

constraint X + Z >= min_XZ;
constraint Y + W >= min_YW;

constraint totalCostScaled = cX*X + cY*Y + cZ*Z + cW*W;

% Objective
solve minimize totalCostScaled;

% Optional output: report minimum cost rounded up to nearest whole number
output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), " W=", show(W), "\n",
  "MinCostScaled(=10*cost)=", show(totalCostScaled), "\n",
  "MinCostRoundedUp=", show((totalCostScaled + scale - 1) div scale), "\n"
];