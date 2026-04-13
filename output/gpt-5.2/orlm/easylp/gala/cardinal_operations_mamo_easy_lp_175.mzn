% Energy investment allocation across projects X, Y, Z
% Data is embedded as required.

include "globals.mzn";

% Parameters
int: XY_max = 100;
int: XZ_min = 150;
int: YZ_max = 200;

int: cX = 3;
int: cY = 4;
int: cZ = 5;

% Decision variables (nonnegative integer investments)
% Upper bounds chosen safely from constraints to keep the model finite.
var 0..150: X;   % from X+Z >= 150 and nonnegativity
var 0..100: Y;   % from X+Y <= 100 and nonnegativity
var 0..200: Z;   % from Y+Z <= 200 and nonnegativity

% Constraints
constraint X + Y <= XY_max;
constraint X + Z >= XZ_min;
constraint Y + Z <= YZ_max;

% Objective: minimize total investment cost
var int: total_cost = cX * X + cY * Y + cZ * Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost = ", show(total_cost), "\n"
];