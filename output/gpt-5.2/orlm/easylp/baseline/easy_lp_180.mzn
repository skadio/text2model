% Resource allocation for Projects X, Y, Z (integers), minimize total cost

var 0..1000: X;
var 0..1000: Y;
var 0..1000: Z;

constraint X + Y + Z <= 1000;
constraint 2*X + Y >= 500;
constraint X + 2*Z <= 600;

var int: total_cost = 6*X + 3*Y + 5*Z;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "Minimum total cost=", show(total_cost), "\n"
];