% Environmental projects funding optimization (all data embedded)

int: costX = 100;
int: costY = 200;

int: maxTotalFunds = 50;

int: minX = 0;
int: maxX = 30;

int: minY = 0;
int: maxY = 20;

int: threshold = 10;

var minX..maxX: X;  % units of funding for reforestation
var minY..maxY: Y;  % units of funding for wildlife conservation

constraint X + Y <= maxTotalFunds;
constraint 3 * X - Y >= threshold;

var int: totalCost = costX * X + costY * Y;

solve minimize totalCost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost ($) = ", show(totalCost), "\n"
];