% Tourism agency resource allocation - embedded data

int: c1 = 100;
int: c2 = 200;
int: c3 = 300;
int: c4 = 400;

var 0..500: x1;
var 0..500: x2;
var 0..600: x3;
var 0..600: x4;

constraint x1 + x2 <= 500;
constraint x3 + x4 <= 600;
constraint x1 + x3 >= 300;
constraint x2 + x4 >= 400;

var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];