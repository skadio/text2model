int: costX = 10;
int: costY = 15;

var 0..1000: x; % units of product X
var 0..1000: y; % units of product Y

constraint 2*x + 3*y >= 40;
constraint 5*x + 4*y <= 100;

solve minimize costX*x + costY*y;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "min_cost = ", show(costX*x + costY*y), "\n"
];