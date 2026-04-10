% Resource allocation among departments X, Y, Z (integer units)
% Minimize total cost subject to constraints.

var 0..1000: X;
var 0..1000: Y;
var 0..1000: Z;

constraint X + Y + Z >= 50;
constraint 4 * X - Y <= 30;
constraint Z - 2 * Y >= 10;

var int: total_cost = 5 * X + 3 * Y + 2 * Z;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "Z=", show(Z), "\n",
  "min_cost=", show(total_cost), "\n"
];