% Resource allocation between two crops X and Y (integer units)
% Minimize total cost subject to constraints.

var 0..200: X;
var 0..200: Y;

constraint 2*X + Y <= 200;
constraint X + 3*Y >= 150;
constraint abs(X - Y) <= 20;

var int: total_cost = 100*X + 50*Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost (rounded to nearest dollar) = $", show(total_cost), "\n"
];