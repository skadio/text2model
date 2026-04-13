int: costX = 5;
int: costY = 7;

var 0..1000: x; % number of vehicles of type X
var 0..1000: y; % number of vehicles of type Y

constraint x + y >= 10;
constraint 2*x + 3*y <= 25;

var int: totalCost = costX * x + costY * y;

solve minimize totalCost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "min_total_cost=", show(totalCost), "\n"
];