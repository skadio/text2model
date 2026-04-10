% Transportation resource allocation - embedded data

var 0..60: x1;
var 0..50: x2;
var 0..150: x3;
var 0..90: x4;

constraint x1 + x2 <= 100;
constraint x3 + x4 <= 200;
constraint x1 + x3 >= 50;
constraint x2 + x4 >= 80;

var int: total_cost = 5*x1 + 10*x2 + 7*x3 + 8*x4;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "x3 = ", show(x3), "\n",
  "x4 = ", show(x4), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];