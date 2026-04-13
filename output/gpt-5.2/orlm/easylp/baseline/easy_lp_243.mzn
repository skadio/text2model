% Resource allocation for construction tasks X, Y, Z (integer hours)
% Minimize total cost subject to constraints.

var 0..50: x;  % man-hours for task X
var 0..50: y;  % man-hours for task Y
var 0..50: z;  % man-hours for task Z

constraint x + y + z <= 50;
constraint 3*x + 4*y + z >= 100;
constraint 2*x - y + z <= 75;

var int: total_cost = 100*x + 200*y + 150*z;

solve minimize total_cost;

output [
  "x=", show(x), " y=", show(y), " z=", show(z), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];