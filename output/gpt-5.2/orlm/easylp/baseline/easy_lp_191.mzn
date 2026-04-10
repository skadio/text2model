int: max_total = 1000;

int: costX = 5;
int: costY = 7;
int: costZ = 3;

var 0..max_total: x; % vehicles on route X
var 0..max_total: y; % vehicles on route Y
var 0..max_total: z; % vehicles on route Z

constraint x + y + z <= 1000;
constraint 2*x + 3*y >= 500;
constraint x + z - y <= 400;
constraint y >= z + 100;

var int: total_cost = costX*x + costY*y + costZ*z;

solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "z=", show(z), "\n",
  "min_total_cost=", show(total_cost), "\n"
];