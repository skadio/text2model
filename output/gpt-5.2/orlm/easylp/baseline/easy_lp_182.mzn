% Resource allocation among projects X, Y, Z (integer units)

var 0..100: X;
var 0..100: Y;
var 0..100: Z;

constraint X + Y + Z <= 100;
constraint X >= 2 * Y;
constraint Z >= X + 10;

var int: total_cost = 10 * X + 20 * Y + 30 * Z;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Z = ", show(Z), "\n",
  "Total cost = $", show(total_cost), "\n"
];