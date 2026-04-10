int: max_units = 100;

int: costX = 5000;
int: costY = 4000;
int: costZ = 6000;

var 0..max_units: x;
var 0..max_units: y;
var 0..max_units: z;

constraint x + y + z <= max_units;

constraint 2*x + y >= 50;
constraint x + z >= 40;

var int: total_cost = costX*x + costY*y + costZ*z;

solve minimize total_cost;

output [
  "x=", show(x), " y=", show(y), " z=", show(z), "\n",
  "total_cost=$", show(total_cost), "\n"
];