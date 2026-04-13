int: max_budget = 1000;
int: min_effectiveness = 2000;

int: eff_x = 2;
int: eff_y = 3;

int: cost_x = 10;
int: cost_y = 20;

var 0..max_budget: X;
var 0..max_budget: Y;

constraint X + Y <= max_budget;
constraint eff_x * X + eff_y * Y >= min_effectiveness;

var int: total_cost = cost_x * X + cost_y * Y;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "min_total_cost=", show(total_cost), "\n"
];