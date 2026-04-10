int: costX = 50;
int: costY = 30;
int: costZ = 20;

int: maxTotal = 500;

int: minExpr2 = 100;   % 3X - Y + Z >= 100
int: maxExpr3 = 200;   % X - 2Y - Z <= 200

var 0..maxTotal: X;
var 0..maxTotal: Y;
var 0..maxTotal: Z;

constraint X + Y + Z <= maxTotal;
constraint 3*X - Y + Z >= minExpr2;
constraint X - 2*Y - Z <= maxExpr3;

var int: totalCost = costX*X + costY*Y + costZ*Z;

solve minimize totalCost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "MinTotalCost=", show(totalCost), "\n"
];