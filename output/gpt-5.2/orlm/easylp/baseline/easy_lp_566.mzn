int: maxX = 1500;
int: maxY = 1300;
int: maxZ = 1200;

var 0..maxX: X;
var 0..maxY: Y;
var 0..maxZ: Z;

% Constraints
constraint X + Y <= 2000;
constraint X + Z >= 1000;
constraint Y - Z = 500;
constraint X - Y >= -700;

% Objective (costs per unit)
var int: total_cost = 50 * X + 60 * Y + 70 * Z;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "total_cost=", show(total_cost), "\n"
];