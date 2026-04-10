% Shipping cargo allocation - embedded data

var 0..700: x1;
var 0..600: x2;
var 0..400: x3;
var 0..500: x4;

constraint x1 + x2 <= 1000;
constraint x3 + x4 <= 800;
constraint x1 + x3 >= 500;
constraint x2 + x4 >= 600;

var int: total_cost = 4*x1 + 3*x2 + 5*x3 + 7*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "min_total_cost=", show(total_cost), "\n"
];