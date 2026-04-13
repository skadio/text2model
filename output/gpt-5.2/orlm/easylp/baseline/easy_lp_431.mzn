% Transportation fleet allocation: minimize operational cost

int: total_trucks_max = 500;
int: min_x = 100;
int: min_y = 200;

int: cost_x = 10;
int: cost_y = 20;

var int: x >= min_x; % trucks on route X
var int: y >= min_y; % trucks on route Y

constraint x + y <= total_trucks_max;

var int: total_cost = cost_x * x + cost_y * y;

solve minimize total_cost;

% Total cost is already an integer number of dollars (rounding not needed).
output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "min_total_operational_cost_dollars=", show(total_cost), "\n"
];