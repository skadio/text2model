% Fleet allocation across routes X, Y, Z

var 0..1000: x; % ships on route X
var 0..1000: y; % ships on route Y
var 0..1000: z; % ships on route Z

constraint x + y + z <= 1000;
constraint 2*x + y >= 500;
constraint abs(y - z) <= 300;

var int: total_cost = 2*x + 3*y + 4*z;

solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "z=", show(z), "\n",
  "min_total_cost=", show(total_cost), "\n",
  "min_total_cost_rounded=", show(total_cost), "\n"
];