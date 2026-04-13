int: costX = 5;
int: costY = 4;
int: costZ = 6;

int: totalVehiclesMax = 1000;
int: minX = 200;
int: minY = 150;
int: minZ = 300;

var int: x;
var int: y;
var int: z;

constraint x >= minX;
constraint y >= minY;
constraint z >= minZ;
constraint x + y + z <= totalVehiclesMax;

var int: totalCost = costX * x + costY * y + costZ * z;

solve minimize totalCost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "z=", show(z), "\n",
  "totalCost=", show(totalCost), "\n"
];