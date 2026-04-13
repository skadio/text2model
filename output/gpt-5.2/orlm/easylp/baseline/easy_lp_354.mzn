% Resource allocation for 4 departments (integer units)
% Minimize total cost subject to given linear constraints.

var 0..1000: x1;
var 0..1000: x2;
var 0..800:  x3;
var 0..800:  x4;

constraint x1 + x2 <= 1000;
constraint 2*x3 + x4 <= 800;
constraint 3*x1 + 4*x2 - x3 >= 500;
constraint x2 >= 2*x4;

var int: total_cost = 20*x1 + 30*x2 + 10*x3 + 15*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "minimum_total_cost_rounded=$", show(total_cost), "\n"
];