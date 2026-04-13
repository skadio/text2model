int: max_inventory = 5000;
int: demand_req = 3000;
int: balance_limit = 2000;

int: costX = 20;
int: costY = 10;

var 0..max_inventory: x; % units of product X
var 0..max_inventory: y; % units of product Y

constraint x + y <= max_inventory;
constraint 2*x + 3*y >= demand_req;
constraint 5*x - y <= balance_limit;

var int: total_cost = costX*x + costY*y;

solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "min_total_cost=", show(total_cost), "\n"
];