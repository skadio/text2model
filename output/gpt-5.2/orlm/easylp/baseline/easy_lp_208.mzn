% Resource allocation minimization (all data embedded)

int: budget_units = 1000;

int: minX = 200; % medical staff units
int: minY = 150; % facilities units
int: minZ = 100; % technology units

int: costX = 10;
int: costY = 15;
int: costZ = 20;

var int: X;
var int: Y;
var int: Z;

constraint X >= minX;
constraint Y >= minY;
constraint Z >= minZ;

constraint X + Y + Z <= budget_units;

var int: total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "Minimum total cost (rounded) = ", show(total_cost), "\n"
];