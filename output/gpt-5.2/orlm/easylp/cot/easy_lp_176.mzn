% Parameters (with values embedded)
int: costX = 10;
int: costY = 15;
int: costZ = 20;

int: X_min = 0;
int: X_max = 2000;
int: Y_min = 0;
int: Y_max = 1500;
int: Z_min = 0;
int: Z_max = 2500;

int: XY_max = 5000;
int: YZ_min = 3000;
int: XZ_max = 4000;

% Variables
var X_min..X_max: X;
var Y_min..Y_max: Y;
var Z_min..Z_max: Z;

var 0..(costX*X_max + costY*Y_max + costZ*Z_max): total_cost;

% Constraints
constraint X + Y <= XY_max;
constraint Y + Z >= YZ_min;
constraint X + Z <= XZ_max;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];