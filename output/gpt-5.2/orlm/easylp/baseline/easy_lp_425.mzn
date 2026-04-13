% Manufacturing cost minimization: products X and Y

int: capacity = 300;
int: demand_rhs = 800;

int: costX = 50;
int: costY = 70;

var 0..capacity: x;  % units of product X
var 0..capacity: y;  % units of product Y

constraint x + y <= capacity;
constraint 3*x + 4*y >= demand_rhs;
constraint x >= y;

var int: total_cost = costX * x + costY * y;

solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "total_cost=$", show(total_cost), "\n"
];