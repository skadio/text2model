int: costX = 5;
int: costY = 6;

var 0..10: X;
var 0..8: Y;

constraint 2*X + 3*Y >= 8;
constraint 4*X + Y <= 16;

var int: totalCost = costX*X + costY*Y;

solve minimize totalCost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "MinCost=", show(totalCost), "\n"
];