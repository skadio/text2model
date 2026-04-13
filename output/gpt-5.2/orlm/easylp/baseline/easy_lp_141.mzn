int: costX = 1000;
int: costY = 2000;

int: minUnits = 10;
int: maxFirepower = 50;

int: fireX = 5;
int: fireY = 3;

var 0..50: X;
var 0..50: Y;

constraint X + Y >= minUnits;
constraint fireX * X + fireY * Y <= maxFirepower;

var int: totalSupport = costX * X + costY * Y;

solve minimize totalSupport;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "min_total_support_points=", show(totalSupport), "\n"
];