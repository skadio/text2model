% Supply chain distribution optimization between warehouses X and Y

int: max_total = 1000;
int: demand_min = 1500;
int: diff_max = 300;

int: cost_x = 10;
int: cost_y = 15;

int: max_x = 700;
int: max_y = 500;

var 0..max_x: x; % units from warehouse X
var 0..max_y: y; % units from warehouse Y

constraint x + y <= max_total;
constraint 2 * x + 3 * y >= demand_min;
constraint abs(x - y) <= diff_max;

var int: total_cost = cost_x * x + cost_y * y;

solve minimize total_cost;

output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "total_units=", show(x + y), "\n",
  "weighted_units=", show(2*x + 3*y), "\n",
  "total_cost=", show(total_cost), "\n"
];