% Environmental initiatives resource allocation (integer linear optimization)

var 0..100: X;
var 0..100: Y;
var 0..100: Z;

constraint X + Y + Z <= 100;
constraint 2*Y + Z >= 50;
constraint X + Z <= 80;

var int: total_cost = 2*X + 3*Y + 1*Z;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "total_cost=", show(total_cost), "\n"
];