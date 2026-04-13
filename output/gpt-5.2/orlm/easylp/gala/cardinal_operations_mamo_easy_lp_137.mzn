% Resource allocation between initiatives X and Y (integers)
% Minimize total cost subject to total allocation bounds and effectiveness requirement.

int: maxTotal = 100;
int: minTotal = 30;

int: costX = 4;
int: costY = 5;

int: effX = 2;
int: effY = 3;

int: minEffectiveness = 120;

var 0..maxTotal: x;   % units allocated to initiative X
var 0..maxTotal: y;   % units allocated to initiative Y

constraint x + y <= maxTotal;
constraint x + y >= minTotal;

constraint effX * x + effY * y >= minEffectiveness;

var int: totalCost = costX * x + costY * y;

solve minimize totalCost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "totalCost = $", show(totalCost), "\n"
];