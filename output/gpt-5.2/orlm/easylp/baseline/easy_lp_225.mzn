% Telecommunications resource allocation (integer linear optimization)

var 0..15: x1;
var 0..10: x2;
var 0..8:  x3;

constraint 2*x1 + x2 >= 10;
constraint x1 + 3*x3 <= 20;
constraint x2 - 4*x3 >= 5;

var int: total_cost = 5*x1 + 3*x2 + 7*x3;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];