int: maxX = 30;
int: maxY = 20;

int: costX = 10000;
int: costY = 15000;

var 0..maxX: x;
var 0..maxY: y;

constraint 5*x + 3*y <= 200;
constraint 10*x + 15*y >= 300;
constraint abs(x - y) <= 50;

var int: total_cost = costX*x + costY*y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_cost = ", show(total_cost), "\n"
];