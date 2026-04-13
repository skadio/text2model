% Resource allocation for tourism projects X, Y, Z
% Minimize total cost subject to budget and bounds, with integer allocations.

var 100..300: X;
var 50..200: Y;
var 20..100: Z;

constraint X + Y + Z <= 500;

int: cX = 40;
int: cY = 60;
int: cZ = 100;

var int: TotalCost = cX * X + cY * Y + cZ * Z;

solve minimize TotalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "TotalCost = ", show(TotalCost), "\n"
];