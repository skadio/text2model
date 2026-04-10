% Resource allocation for tourism areas X, Y, Z
% Minimize total cost subject to constraints.

int: TOTAL_MAX = 100;

int: costX = 500;
int: costY = 300;
int: costZ = 700;

int: minX = 20;
int: minY = 30;
int: minZ = 10;

var int: X;
var int: Y;
var int: Z;

constraint X >= minX;
constraint Y >= minY;
constraint Z >= minZ;

% Total resources constraint
constraint X + Y + Z <= TOTAL_MAX;

% Interpreting "at least twice as much as that subtracted from ..."
% as: X >= 2*(Y - X)  and  Y >= 2*(Z - Y)
constraint X >= 2 * (Y - X);
constraint Y >= 2 * (Z - Y);

var int: total_cost = costX * X + costY * Y + costZ * Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Total cost ($) = ", show(total_cost), "\n"
];