% Ship allocation between Route X and Route Y (integer ships)

int: max_total_ships = 100;
int: demand_requirement = 60;
int: balance_limit = 30;

int: cost_x = 10;
int: cost_y = 20;

int: max_x = 70;
int: max_y = 50;

var 0..max_x: x; % ships on Route X
var 0..max_y: y; % ships on Route Y

constraint x + y <= max_total_ships;
constraint 2 * x + y >= demand_requirement;
constraint abs(x - y) <= balance_limit;

var int: total_cost = cost_x * x + cost_y * y;

solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "total_cost=", show(total_cost), "\n"
];