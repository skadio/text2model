% Military unit deployment - minimize total support points (in dollars)

var 0..10: X;
var 0..10: Y;
var 0..20: Z;
var 0..20: W;

constraint X + Y <= 10;
constraint Z + W <= 20;
constraint X + Z >= 5;
constraint Y + W >= 7;

var int: total_support =
    1000 * X +
    2000 * Y +
     500 * Z +
    1500 * W;

solve minimize total_support;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "W=", show(W), "\n",
  "total_support=", show(total_support), "\n"
];