% Construction projects resource allocation (embedded data)

int: costX = 5000;
int: costY = 8000;

int: maxTotalUnits = 100;
int: minDiffXY = 20;          % X >= Y + 20
int: maxPortfolio = 150;      % X + 2Y <= 150

var 0..maxTotalUnits: X;
var 0..maxTotalUnits: Y;

constraint X + Y <= maxTotalUnits;
constraint X - Y >= minDiffXY;
constraint X + 2 * Y <= maxPortfolio;

var int: totalCost = costX * X + costY * Y;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost = $", show(totalCost), "\n"
];