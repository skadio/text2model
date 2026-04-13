% Transportation resource allocation (integer units)
% Minimize total cost subject to constraints.

var 0..1000: x; % route X allocation
var 0..1000: y; % route Y allocation
var 0..1000: z; % route Z allocation

constraint x + y + z <= 1000;
constraint 2 * x - y >= 200;
constraint abs(y - z) <= 50;

var int: total_cost = 10 * x + 20 * y + 30 * z;

solve minimize total_cost;

output [
  "x=", show(x), " y=", show(y), " z=", show(z), "\n",
  "min_total_cost=", show(total_cost), "\n"
];