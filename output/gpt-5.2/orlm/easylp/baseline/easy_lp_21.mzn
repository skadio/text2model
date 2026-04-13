% Manufacturing production planning: minimize total cost

int: costX = 5000;
int: costY = 3000;

int: capacity = 1000;
int: demand = 2000;
int: diffMin = 150;

var 0..capacity: x;  % units of product X
var 0..capacity: y;  % units of product Y

constraint x + y <= capacity;
constraint 3 * x + 2 * y >= demand;
constraint x - y >= diffMin;

var int: total_cost = costX * x + costY * y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_cost = ", show(total_cost), "\n"
];