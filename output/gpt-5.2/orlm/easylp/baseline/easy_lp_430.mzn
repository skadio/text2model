% Resource allocation for services X and Y (integer units)

var 0..20: x;  % resources allocated to service X
var 0..20: y;  % resources allocated to service Y

constraint x + y <= 20;
constraint x + 2*y >= 10;
constraint 2*x - y <= 15;

var int: total_cost = 5*x + 4*y;

solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "min_total_cost=", show(total_cost), "\n"
];