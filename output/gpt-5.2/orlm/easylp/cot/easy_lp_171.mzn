% Parameters (with values embedded)
int: max_XY = 1000;
int: max_YZ = 800;
int: min_XZ = 500;

int: roi_X = 2;
int: roi_Y = 3;
int: roi_Z = 5;

% Variables
var 0..max_XY: X;
var 0..max_XY: Y;
var 0..max_YZ: Z;

var 0..(max_XY + max_YZ): total_cost;

% Constraints
constraint X + Y <= max_XY;
constraint Y + Z <= max_YZ;
constraint X + Z >= min_XZ;

constraint total_cost = X + Y + Z;

% Objective
solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Total cost = ", show(total_cost), "\n",
  "Total ROI = ", show(roi_X*X + roi_Y*Y + roi_Z*Z), "\n"
];