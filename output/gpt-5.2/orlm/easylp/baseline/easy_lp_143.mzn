% Resource allocation between unit types X and Y (integer units)

var 0..100: X;
var 0..100: Y;

constraint 2*X + Y >= 10;
constraint X + 4*Y <= 50;

var int: total_support = 5*X + 3*Y;

solve minimize total_support;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total support points (rounded) = ", show(total_support), "\n"
];