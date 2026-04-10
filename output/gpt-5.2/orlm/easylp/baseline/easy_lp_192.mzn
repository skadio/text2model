int: costX = 5;
int: costY = 7;
int: costZ = 3;

int: maxTotal = 50;
int: maxX = 20;
int: maxY = 30;
int: maxZ = 25;

var 0..maxX: x;
var 0..maxY: y;
var 0..maxZ: z;

constraint x + y + z <= maxTotal;
constraint x >= y + 10;
constraint y + z <= 40;

var int: totalCost = costX * x + costY * y + costZ * z;

solve minimize totalCost;

output [
  "x=", show(x), " y=", show(y), " z=", show(z), "\n",
  "min_daily_cost=", show(totalCost), "\n"
];