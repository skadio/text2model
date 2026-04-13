int: c1 = 100;
int: c2 = 200;
int: c3 = 150;
int: c4 = 250;

var 0..5000: x1;
var 0..5000: x2;
var 0..6000: x3;
var 0..6000: x4;

constraint x1 + x2 <= 5000;
constraint x3 + x4 <= 6000;
constraint x1 + x3 >= 3000;
constraint x2 + x4 >= 4000;

var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "min_total_cost=", show(total_cost), "\n"
];