% Military logistics resource distribution (integer linear optimization)

var 0..700: X;
var 0..400: Y;

constraint X + Y <= 1000;
constraint 2 * X + Y >= 500;

var int: total_support = 500 * X + 300 * Y;

solve minimize total_support;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "minimum_total_support = ", show(total_support), "\n"
];