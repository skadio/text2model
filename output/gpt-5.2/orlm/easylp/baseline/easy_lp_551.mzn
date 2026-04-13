int: maxTotal = 1000;

int: costX = 50;
int: costY = 60;
int: costZ = 70;

int: maxX = 500;
int: maxY = 400;
int: maxZ = 300;

int: diffXY = 200; % X at least 200 more than Y
int: diffYZ = 100; % Y at least 100 more than Z

var 0..maxX: x;
var 0..maxY: y;
var 0..maxZ: z;

constraint x + y + z <= maxTotal;
constraint x >= y + diffXY;
constraint y >= z + diffYZ;

var int: totalCost = costX * x + costY * y + costZ * z;

solve minimize totalCost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "z=", show(z), "\n",
  "totalCost=", show(totalCost), "\n"
];