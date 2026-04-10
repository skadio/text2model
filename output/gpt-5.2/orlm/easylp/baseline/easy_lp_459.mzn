% Scheduling allocation between tasks X and Y

var int: x; % hours for task X
var int: y; % hours for task Y

constraint x >= 0 /\ y >= 0;
constraint x + y >= 50;
constraint 2*x + y <= 120;
constraint x >= y;

var int: total_cost = 8*x + 10*y;

solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "min_total_cost=", show(total_cost), "\n"
];