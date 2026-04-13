% Tourism package allocation - minimize total cost

var 0..500: x1;
var 0..500: x2;
var 0..700: x3;
var 0..700: x4;

constraint x1 + x2 <= 500;
constraint x3 + x4 <= 700;
constraint x1 + x3 >= 200;
constraint x2 + x4 >= 300;

var int: total_cost = 100*x1 + 200*x2 + 300*x3 + 400*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];