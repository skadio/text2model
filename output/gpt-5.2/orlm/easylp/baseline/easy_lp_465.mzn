% HR allocation problem: minimize total cost with integer hours

int: minX = 10;
int: minY = 5;
int: maxTotal = 40;

int: costX = 50;
int: costY = 80;

var int: hoursX;
var int: hoursY;

constraint hoursX >= minX;
constraint hoursY >= minY;
constraint hoursX + hoursY <= maxTotal;

var int: totalCost = costX * hoursX + costY * hoursY;

solve minimize totalCost;

output [
  "hoursX=", show(hoursX), "\n",
  "hoursY=", show(hoursY), "\n",
  "totalCost=", show(totalCost), "\n"
];