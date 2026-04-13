int: TOTAL_MAX = 1000;

int: cX = 2;
int: cY = 3;
int: cZ = 4;

var 0..TOTAL_MAX: X;
var 0..TOTAL_MAX: Y;
var 0..TOTAL_MAX: Z;

constraint X + Y + Z <= TOTAL_MAX;
constraint X >= Y + 50;
constraint abs(Z - X) <= 200;
constraint Y + Z >= 400;

var int: total_cost = cX*X + cY*Y + cZ*Z;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "total_cost=", show(total_cost), "\n"
];