% Manufacturing cost minimization for products X, Y, Z (all integer units)

int: capacity = 500;

int: costX = 50;
int: costY = 60;
int: costZ = 20;

int: minX = 0; int: maxX = 300;
int: minY = 0; int: maxY = 200;
int: minZ = 0; int: maxZ = 100;

var minX..maxX: X;
var minY..maxY: Y;
var minZ..maxZ: Z;

constraint X + Y + Z <= capacity;

% Demand constraints
constraint 2*X + Y >= 200;
constraint Y + Z >= 150;

var int: total_cost = costX*X + costY*Y + costZ*Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];