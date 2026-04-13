int: MAX_UNITS = 150;

int: reqX = 3;
int: reqY = 4;
int: minStrength = 100;

int: diffZX = 30;
int: minYminusZ = 20;

int: costX = 10000;
int: costY = 2000;
int: costZ = 500;

var 0..MAX_UNITS: X;
var 0..MAX_UNITS: Y;
var 0..MAX_UNITS: Z;

constraint X + Y + Z <= MAX_UNITS;
constraint reqX * X + reqY * Y >= minStrength;
constraint abs(Z - X) <= diffZX;
constraint Y >= Z + minYminusZ;

var int: total_support = costX * X + costY * Y + costZ * Z;

solve minimize total_support;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "min_total_support_points=", show(total_support), "\n"
];