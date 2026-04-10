int: reqX = 500;
int: reqY = 400;
int: reqZ = 700;
int: budget = 1000;

var 0..budget: x;
var 0..budget: y;
var 0..budget: z;

constraint x >= reqX;
constraint y >= reqY;
constraint z >= reqZ;

constraint x + y + z <= budget;

constraint 2 * x - y >= 200;
constraint z - y >= 50;

var 0..budget: total = x + y + z;

solve minimize total;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "z=", show(z), "\n",
  "total=", show(total), "\n"
];