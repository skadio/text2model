% Resource allocation for three telecom projects
% Minimize total cost subject to linear constraints and integer bounds.

var 0..500: x1;
var 0..300: x2;
var 0..400: x3;

constraint x1 + 2*x2 <= 1000;
constraint 3*x1 - x2 + x3 >= 500;
constraint -x1 + 4*x2 - 2*x3 = 200;

var int: total_cost = 5*x1 + 4*x2 + 3*x3;

solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "total_cost=", show(total_cost), "\n"
];