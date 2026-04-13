% Vehicle allocation: trucks (x) and vans (y), both nonnegative integers

int: demand_rhs = 15;          % 4x + 3y >= 15
int: restriction_rhs = 30;     % 2x + y <= 30

int: cost_truck = 6;
int: cost_van   = 7;

% Safe upper bounds from constraints: 2x + y <= 30 => x <= 15, y <= 30
var 0..15: x;   % trucks
var 0..30: y;   % vans

constraint 4*x + 3*y >= demand_rhs;
constraint 2*x + y <= restriction_rhs;

var int: total_cost = cost_truck*x + cost_van*y;

solve minimize total_cost;

output [
  "trucks=", show(x), "\n",
  "vans=", show(y), "\n",
  "min_daily_cost_dollars=", show(total_cost), "\n"
];