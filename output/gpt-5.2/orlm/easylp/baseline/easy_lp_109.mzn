int: costX = 20;
int: costY = 30;

var 0..100: x; % hours for exercise X
var 0..100: y; % hours for exercise Y

constraint x + y >= 15;
constraint 2*x + y <= 40;

var int: total_cost = costX*x + costY*y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];