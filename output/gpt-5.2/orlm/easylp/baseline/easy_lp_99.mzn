int: maxHires = 50;

int: costX = 5000;
int: costY = 8000;

var 0..maxHires: X;
var 0..maxHires: Y;

constraint X + Y <= maxHires;

% "X at least three times the number of those not hired for position Y
% (considering the total hires allowed)" => not hired for Y = maxHires - Y
constraint X >= 3 * (maxHires - Y);

var int: totalCost = costX * X + costY * Y;

solve minimize totalCost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "TotalCost=", show(totalCost), "\n"
];