int: costX = 10;
int: costY = 15;
int: costZ = 20;

int: maxX = 700;
int: maxY = 600;
int: maxZ = 400;

int: maxXY = 1000;
int: maxYZ = 800;
int: minXZ = 500;

var 0..maxX: x;
var 0..maxY: y;
var 0..maxZ: z;

constraint x + y <= maxXY;
constraint y + z <= maxYZ;
constraint x + z >= minXZ;

var int: total_cost = costX * x + costY * y + costZ * z;

solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "z=", show(z), "\n",
  "min_total_cost=", show(total_cost), "\n"
];