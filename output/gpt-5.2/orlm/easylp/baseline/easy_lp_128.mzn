int: costX = 20;
int: costY = 30;

var 0..50: x; % units of Project X (trees)
var 0..50: y; % units of Project Y (river cleaning)

constraint 3*x + y >= 10;      % minimum effectiveness
constraint x + 5*y <= 50;      % budget/manpower limit

var int: total_cost = costX*x + costY*y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];