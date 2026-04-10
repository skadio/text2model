int: c1 = 2;
int: c2 = 3;
int: c3 = 4;
int: c4 = 5;

var 0..100: x1;
var 0..100: x2;
var 0..200: x3;
var 0..200: x4;

constraint x1 + x2 <= 100;
constraint x3 + x4 <= 200;
constraint x1 + x3 >= 50;
constraint x2 + x4 >= 150;

var int: total_cost = c1*x1 + c2*x2 + c3*x3 + c4*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n",
  "rounded_total_cost=", show(total_cost), "\n"
];