% Production planning: minimize cost with capacity and demand constraints

var 0..200: X;
var 0..200: Y;

constraint X + Y <= 200;
constraint 3 * X + 2 * Y >= 400;

var int: total_cost = 500 * X + 300 * Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost (rounded to nearest dollar) = $", show(total_cost), "\n"
];