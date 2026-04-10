% Parameters (with values embedded)
int: costX = 5;
int: costY = 7;
int: costZ = 3;

int: maxX = 100;
int: maxY = 80;
int: maxZ = 60;

% Variables
var 0..maxX: X;
var 0..maxY: Y;
var 0..maxZ: Z;

var int: total_cost = costX * X + costY * Y + costZ * Z;

% Constraints
constraint 2 * X + 3 * Y + Z >= 30;
constraint X + 4 * Y + 2 * Z <= 50;
constraint X - Y + Z >= 10;

% Objective
solve minimize total_cost;

output [
  "Minimum total cost = ", show(total_cost), "\n",
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n"
];