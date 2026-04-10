int: costX = 5;
int: costY = 10;
int: costZ = 7;

int: totalResources = 1000;

int: minX = 200;
int: maxY = 400;
int: minZ = 150;

var 0..totalResources: x;
var 0..totalResources: y;
var 0..totalResources: z;

constraint x + y + z <= totalResources;
constraint x >= minX;
constraint y <= maxY;
constraint z >= minZ;

var int: totalCost = costX * x + costY * y + costZ * z;

solve minimize totalCost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "z=", show(z), "\n",
  "totalCost=", show(totalCost), "\n"
];