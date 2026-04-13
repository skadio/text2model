% Inventory optimization for two product categories X and Y

int: costX = 20;
int: costY = 30;

int: maxTotal = 500;
int: maxX = 400;
int: maxY = 300;

int: minEffect = 1000;

% "four times the units from category X should not exceed by more than 600 from those of category Y"
% Interpreted as: 4*X - Y <= 600
int: diffLimit = 600;

var 0..maxX: X;
var 0..maxY: Y;

constraint X + Y <= maxTotal;
constraint 3*X + 2*Y >= minEffect;
constraint 4*X - Y <= diffLimit;

var int: totalCost = costX*X + costY*Y;

solve minimize totalCost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Minimum total cost ($)=", show(totalCost), "\n"
];