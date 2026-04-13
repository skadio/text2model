int: costX = 4;
int: costY = 5;

var 0..1000: x; % units for department X (integer)
var 0..1000: y; % units for department Y (integer)

constraint x + 3*y >= 10;
constraint 2*x + y <= 30;

var int: total_cost = costX * x + costY * y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];