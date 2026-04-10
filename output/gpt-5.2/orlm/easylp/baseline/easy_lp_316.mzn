% Military logistics resource allocation (integer linear optimization)

var 0..1000: X;
var 0..1000: Y;
var 0..1000: Z;

constraint X + Y + Z <= 1000;
constraint 2*X + Y >= 400;
constraint Y + Z <= 600;

var int: total_cost = 4*X + 3*Y + 5*Z;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "min_total_cost=", show(total_cost), "\n"
];