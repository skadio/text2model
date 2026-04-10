% Military logistics resource allocation - embedded data

int: max_total_resources = 10000;
int: min_strategic_requirement = 6000;
int: max_imbalance = 2000;

int: cost_X = 5000; % dollars per unit for division X
int: cost_Y = 3000; % dollars per unit for division Y

var 0..max_total_resources: X;
var 0..max_total_resources: Y;

constraint X + Y <= max_total_resources;
constraint 2*X + Y >= min_strategic_requirement;
constraint abs(X - Y) <= max_imbalance;

var int: total_cost = cost_X * X + cost_Y * Y;

solve minimize total_cost;

output [
  "X = ", show(X), "\n",
  "Y = ", show(Y), "\n",
  "Minimum total cost ($) = ", show(total_cost), "\n"
];