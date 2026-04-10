int: budget = 500;

int: minX = 100; int: maxX = 300; % Residential
int: minY = 50;  int: maxY = 200; % Commercial
int: minZ = 30;  int: maxZ = 150; % Industrial

int: rX = 100; % $ per unit
int: rY = 200;
int: rZ = 150;

var minX..maxX: X;
var minY..maxY: Y;
var minZ..maxZ: Z;

constraint X + Y + Z <= budget;

var int: total_cost = rX*X + rY*Y + rZ*Z;

solve minimize total_cost;

output [
  "X(residential) = ", show(X), " units\n",
  "Y(commercial)  = ", show(Y), " units\n",
  "Z(industrial)  = ", show(Z), " units\n",
  "Total units    = ", show(X+Y+Z), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];