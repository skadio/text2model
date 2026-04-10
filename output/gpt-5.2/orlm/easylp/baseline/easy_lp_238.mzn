int: Rmax = 5000;

int: costX = 100;
int: costY = 200;
int: costZ = 150;

var 0..Rmax: x;
var 0..Rmax: y;
var 0..Rmax: z;

constraint x + y + z <= Rmax;
constraint x >= 3 * y;
constraint z >= 2 * y;

var int: total_cost = costX * x + costY * y + costZ * z;

solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "z=", show(z), "\n",
  "total_cost=", show(total_cost), "\n"
];