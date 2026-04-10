% Scheduling cost minimization with integer hours

var 0..100: x; % hours for task X (integer)
var 0..100: y; % hours for task Y (integer)

constraint x + y >= 10;
constraint 2*x + 3*y <= 24;

var int: total_cost = 8*x + 5*y;

solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "min_total_cost=", show(total_cost), "\n"
];