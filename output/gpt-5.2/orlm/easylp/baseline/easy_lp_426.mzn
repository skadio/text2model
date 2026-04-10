int: costX = 50;
int: costY = 75;

int: maxTotal = 1200;
int: minGap = 300;          % X - Y >= 300
int: storageLimit = 2000;   % 2X + Y <= 2000

var 0..maxTotal: X;
var 0..maxTotal: Y;

constraint X + Y <= maxTotal;
constraint X - Y >= minGap;
constraint 2*X + Y <= storageLimit;

var int: totalCost = costX*X + costY*Y;

solve minimize totalCost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "TotalCost=", show(totalCost), "\n"
];