% Resource allocation between two projects X and Y (integer units)

var 0..100: x;  % units for project X
var 0..80:  y;  % units for project Y

constraint 2*x + 3*y >= 200;
constraint 4*x + y <= 300;
constraint x >= y;

var int: total_cost = 500*x + 600*y;

solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "min_total_cost_dollars=", show(total_cost), "\n"
];