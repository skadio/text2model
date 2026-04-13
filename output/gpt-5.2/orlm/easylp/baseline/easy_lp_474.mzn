% Tourism tours planning: minimize total cost

var 0..50: x; % number of Tour X
var 0..50: y; % number of Tour Y

constraint x + y <= 50;
constraint 2*x + 4*y >= 40;
constraint 3*x - y <= 60;

var int: total_cost = 500*x + 1000*y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];