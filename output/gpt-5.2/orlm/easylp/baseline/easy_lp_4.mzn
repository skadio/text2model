% Marketing budget allocation between two channels (X and Y)
% Minimize total cost subject to budget and effectiveness constraints.

int: max_total_budget = 5000;

int: eff_x = 3;
int: eff_y = 4;
int: min_effectiveness = 12000;

int: balance_x = 5;
int: balance_y = -2; % 5*X - 2*Y <= 10000
int: max_balance = 10000;

int: cost_x = 200;
int: cost_y = 150;

var 0..max_total_budget: x; % dollars allocated to channel X
var 0..max_total_budget: y; % dollars allocated to channel Y

constraint x + y <= max_total_budget;
constraint eff_x * x + eff_y * y >= min_effectiveness;
constraint balance_x * x + balance_y * y <= max_balance;

var int: total_cost = cost_x * x + cost_y * y;

solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_budget = ", show(x + y), "\n",
  "effectiveness = ", show(eff_x * x + eff_y * y), "\n",
  "balance = ", show(balance_x * x - 2 * y), "\n",
  "total_cost = ", show(total_cost), "\n"
];