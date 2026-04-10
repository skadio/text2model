% Tourism services cost minimization (all data embedded)

int: max_total_services = 200;
int: min_X = 50;
int: min_Y = 30;

int: cost_X = 300;
int: cost_Y = 500;

var int: X; % local sightseeing tours
var int: Y; % adventure activities

constraint X >= min_X;
constraint Y >= min_Y;
constraint X + Y <= max_total_services;

var int: total_cost = cost_X * X + cost_Y * Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "minimum_monthly_operational_cost = $", show(total_cost), "\n"
];