int: BUDGET = 1000;

int: minX = 200;
int: minY = 150;
int: minZ = 100;

int: maxDiffXY = 50;  % X should not exceed Y by more than 50 => X <= Y + 50
int: minDiffYZ = 20;  % Y should be at least 20 more than Z => Y >= Z + 20

int: costX = 300;
int: costY = 500;
int: costZ = 200;

var int: X;
var int: Y;
var int: Z;

constraint X >= minX;
constraint Y >= minY;
constraint Z >= minZ;

constraint X + Y + Z <= BUDGET;

constraint X <= Y + maxDiffXY;
constraint Y >= Z + minDiffYZ;

solve minimize costX * X + costY * Y + costZ * Z;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Minimum total cost = $", show(costX * X + costY * Y + costZ * Z), "\n"
];