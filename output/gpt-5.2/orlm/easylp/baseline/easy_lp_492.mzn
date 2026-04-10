% Military resource allocation (integer optimization)

int: MAX_UNITS = 10000;
int: MIN_STRENGTH = 7000;
int: BALANCE_LIMIT = 2000;

int: costX = 5000;
int: costY = 3000;

var 0..MAX_UNITS: X;
var 0..MAX_UNITS: Y;

constraint X + Y <= MAX_UNITS;
constraint 2*X + Y >= MIN_STRENGTH;
constraint X - 2*Y <= BALANCE_LIMIT;

var int: total_support = costX*X + costY*Y;

solve minimize total_support;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total support points (rounded) = ", show(total_support), "\n"
];