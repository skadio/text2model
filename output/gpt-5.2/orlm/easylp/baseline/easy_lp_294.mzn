int: budget = 100;

int: minX = 30;
int: minY = 20;
int: minZ = 10;

int: costX = 20;
int: costY = 15;
int: costZ = 10;

var minX..budget: x;
var minY..budget: y;
var minZ..budget: z;

constraint x + y + z <= budget;

var int: total_cost = costX * x + costY * y + costZ * z;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "z = ", show(z), "\n",
  "total_cost = ", show(total_cost), "\n"
];