% Resource allocation for projects X, Y, Z (integer units)
% Minimize total cost subject to constraints and bounds.

var 0..200: x;
var 0..150: y;
var 0..300: z;

constraint 2*x + 3*y + z >= 500;
constraint x + y + 4*z <= 800;
constraint x - y + z >= 100;

var int: total_cost = 50*x + 60*y + 70*z;

solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "z=", show(z), "\n",
  "total_cost=", show(total_cost), "\n"
];