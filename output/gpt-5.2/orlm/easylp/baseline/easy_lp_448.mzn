int: costX = 50;
int: costY = 100;

var int: x; % units allocated to project X
var int: y; % units allocated to project Y

constraint x + y <= 2000;
constraint x - 2*y >= 500;
constraint x >= 750;
constraint x >= 0 /\ y >= 0;

var int: total_cost = costX * x + costY * y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_cost = $", show(total_cost), "\n"
];