% Telecommunications resource allocation: minimize total cost

int: max_total = 10000;
int: min_requirement = 5000;
int: balance_limit = 3000;

int: costX = 10;
int: costY = 20;
int: costZ = 30;

var 0..max_total: x;
var 0..max_total: y;
var 0..max_total: z;

constraint x + y + z <= max_total;
constraint 2*x + 3*y + z >= min_requirement;
constraint x - y + z <= balance_limit;

var int: total_cost = costX*x + costY*y + costZ*z;

solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "z=", show(z), "\n",
  "min_total_cost=", show(total_cost), "\n"
];