% Hiring employees in departments X, Y, Z to minimize total cost

var 0..100: x; % hires in department X
var 0..100: y; % hires in department Y
var 0..100: z; % hires in department Z

% Constraints
constraint x + y + z <= 100;
constraint x >= 20;
constraint y >= 30;
constraint z >= 10;

% Costs (in dollars)
int: costX = 50000;
int: costY = 60000;
int: costZ = 70000;

var int: total_cost = costX * x + costY * y + costZ * z;

solve minimize total_cost;

output [
  "x=", show(x), " y=", show(y), " z=", show(z), "\n",
  "minimum_total_cost=", show(total_cost), "\n"
];