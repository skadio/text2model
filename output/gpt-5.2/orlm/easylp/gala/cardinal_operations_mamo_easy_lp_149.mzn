% Shipping cost minimization with two vehicle types X and Y

% Data (embedded as requested)
int: min_total_goods = 50;
int: max_diff = 30;
int: cost_x = 20;
int: cost_y = 15;

% Decision variables: number of goods carried by each vehicle type
var 0..1000: X;
var 0..1000: Y;

% Constraints
constraint X + Y >= min_total_goods;
constraint abs(X - Y) <= max_diff;

% Objective: minimize total cost
var 0..intmax: total_cost = cost_x * X + cost_y * Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "TotalCost = $", show(total_cost), "\n"
];