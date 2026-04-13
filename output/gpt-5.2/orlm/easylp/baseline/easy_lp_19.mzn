% Manufacturing products X and Y - cost minimization with linear constraints

var 0..1000: x; % units of product X (integer)
var 0..1000: y; % units of product Y (integer)

constraint 2*x + 3*y <= 100;
constraint 4*x + y >= 50;

var int: total_cost = 5*x + 10*y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];