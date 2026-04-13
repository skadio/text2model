% Energy investment allocation: minimize total cost with integer investments

var 0..1000: X;
var 0..1000: Y;
var 0..1000: Z;

constraint X + Y + Z <= 1000;
constraint 5*X - 2*Y >= 200;
constraint Z - Y <= 300;
constraint X >= Z + 50;

var int: total_cost = 2*X + 3*Y + 4*Z;

solve minimize total_cost;

output [
  "X=", show(X), " Y=", show(Y), " Z=", show(Z), "\n",
  "min_total_cost=", show(total_cost), "\n"
];