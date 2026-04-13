% Resource allocation for four telecom projects
% Minimize total cost subject to linear constraints and integer bounds.

var 0..100: x1;
var 0..80:  x2;
var 0..60:  x3;
var 0..70:  x4;

constraint x1 + 2*x2 <= 50;
constraint 3*x3 - x4 >= 20;
constraint x2 + x3 - x1 <= 30;
constraint 3*x4 - x2 >= 10;

var int: total_cost = 4*x1 + 5*x2 + 6*x3 + 7*x4;

solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "min_total_cost=", show(total_cost), "\n",
  "rounded_min_total_cost=", show(total_cost), "\n"
];