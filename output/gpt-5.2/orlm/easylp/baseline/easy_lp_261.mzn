% Hiring optimization for departments X, Y, Z with all data embedded

int: costX = 5000;
int: costY = 4000;
int: costZ = 6000;

int: totalHires = 50;

int: expX = 5;
int: expY = 3;
int: expZ = 7;
int: minExperience = 200;

int: minX = 10;
int: maxY = 20;

var int: x; % hires in X
var int: y; % hires in Y
var int: z; % hires in Z

constraint x >= 0 /\ y >= 0 /\ z >= 0;
constraint x + y + z = totalHires;

constraint expX * x + expY * y + expZ * z >= minExperience;

constraint x >= minX;
constraint y <= maxY;

var int: totalCost = costX * x + costY * y + costZ * z;

solve minimize totalCost;

output [
  "x=", show(x), " y=", show(y), " z=", show(z), "\n",
  "totalCost=", show(totalCost), "\n"
];