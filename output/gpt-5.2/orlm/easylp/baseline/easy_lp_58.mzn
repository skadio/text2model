int: maxTotal = 100;
int: minDiversity = 50;

int: maxX = 60;
int: maxY = 70;

int: profitX = 5;
int: profitY = 3;

var 0..maxX: X;
var 0..maxY: Y;

constraint X + Y <= maxTotal;
constraint 2*X + Y >= minDiversity;

var int: totalProfit = profitX*X + profitY*Y;

solve maximize totalProfit;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "TotalProfit=", show(totalProfit), "\n"
];