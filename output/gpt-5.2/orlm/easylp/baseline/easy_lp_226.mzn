% Resource allocation optimization for three projects

var 0..400: x1;
var 0..300: x2;
var 0..600: x3;

constraint x1 + x2 + x3 <= 1000;
constraint 2 * x1 - 3 * x3 >= 500;
constraint 4 * x2 + x3 <= 1200;

var int: total_cost = 3 * x1 + 2 * x2 + 5 * x3;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];