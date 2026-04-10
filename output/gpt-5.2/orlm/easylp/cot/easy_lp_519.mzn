% Parameters (with values embedded)
int: total_capacity_max = 500;

int: minX = 100;
int: minY = 150;
int: minZ = 200;

int: lbX = 0;  int: ubX = 300;
int: lbY = 0;  int: ubY = 400;
int: lbZ = 0;  int: ubZ = 600;

int: costX = 5;
int: costY = 10;
int: costZ = 15;

% Variables
var lbX..ubX: X;
var lbY..ubY: Y;
var lbZ..ubZ: Z;

var 0..(costX*ubX + costY*ubY + costZ*ubZ): total_cost;

% Constraints
constraint X + Y + Z <= total_capacity_max;

constraint X >= minX;
constraint Y >= minY;
constraint Z >= minZ;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost (rounded) = ", show(total_cost), "\n"
];