int: maxTotal = 20;
int: minDiff = 5;

int: maxX = 15;
int: maxY = 10;

int: fatigueX = 2;
int: fatigueY = 3;

var 0..maxX: x; % hours for exercise X (integer)
var 0..maxY: y; % hours for exercise Y (integer)

constraint x + y <= maxTotal;
constraint x >= y + minDiff;

var int: totalFatigue = fatigueX * x + fatigueY * y;

solve minimize totalFatigue;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "min_total_fatigue=", show(totalFatigue), "\n"
];