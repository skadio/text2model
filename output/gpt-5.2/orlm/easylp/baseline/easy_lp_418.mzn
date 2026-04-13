int: powerX = 60;
int: powerY = 90;

int: maxWeighted = 1200;
int: minTotalAlloc = 100;

var 0..10000: x; % allocation to plant X (integer)
var 0..10000: y; % allocation to plant Y (integer)

constraint 2*x + 3*y <= maxWeighted;
constraint x >= y;
constraint x + y >= minTotalAlloc;

var int: total_power = powerX*x + powerY*y;

solve minimize total_power;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_power = ", show(total_power), "\n"
];