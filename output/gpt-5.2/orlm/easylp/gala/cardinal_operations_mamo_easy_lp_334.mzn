% Energy investment allocation - minimize total cost
% All data embedded as per instructions.

int: maxXY = 5000;
int: maxZW = 2000;

int: X_max = 4000;
int: Y_max = 3000;
int: Z_min = 500;
int: W_min = 200;

int: X_ge_Z_plus = 1000;
int: Y_ge_W_plus = 1500;

int: cX = 20;
int: cY = 30;
int: cZ = 50;
int: cW = 10;

% Decision variables (integer investments)
var 0..X_max: X;
var 0..Y_max: Y;
var Z_min..maxZW: Z;                 % Z must be >= 500 and also within Z+W <= 2000
var W_min..maxZW: W;                 % W must be >= 200 and also within Z+W <= 2000

% Constraints
constraint X + Y <= maxXY;
constraint Z + W <= maxZW;

constraint X >= Z + X_ge_Z_plus;
constraint Y >= W + Y_ge_W_plus;

% Objective: minimize total cost
var int: total_cost = cX*X + cY*Y + cZ*Z + cW*W;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "W = ", show(W), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];