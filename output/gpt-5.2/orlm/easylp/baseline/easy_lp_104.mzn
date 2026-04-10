int: costX = 50;
int: costY = 80;

var 0..100: x; % employees on Project X
var 0..100: y; % employees on Project Y

constraint x + y >= 20;
constraint 2 * x + y <= 40;

var int: total_cost = costX * x + costY * y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_daily_cost = $", show(total_cost), "\n"
];