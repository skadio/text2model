% Resource allocation across projects X, Y, Z
% Minimize total cost subject to capacity, effectiveness, and balance constraints.

var 0..50: x;
var 0..50: y;
var 0..50: z;

constraint x + y + z <= 50;

% Effectiveness requirement
constraint 3*x + 4*y + 5*z >= 150;

% Difference between X and Y not more than 10
constraint abs(x - y) <= 10;

% Objective: minimize total cost in dollars
var int: total_cost = 2000*x + 3000*y + 4000*z;

solve minimize total_cost;

output [
  "x=", show(x), " y=", show(y), " z=", show(z), "\n",
  "total_cost=", show(total_cost), "\n"
];