int: profitX = 10;
int: profitY = 5;

var 0..1000: x; % units of product X (integer stock/sales)
var 0..1000: y; % units of product Y (integer stock/sales)

constraint 2*x + y >= 50;
constraint x + 3*y <= 150;

var int: profit = profitX * x + profitY * y;

solve maximize profit;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "profit=", show(profit), "\n"
];