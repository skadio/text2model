% Marketing budget allocation (integer dollars), minimize total cost

int: max_budget = 5000;

int: eff_x = 3;
int: eff_y = 4;
int: min_eff = 12000;

int: bal_x = 5;
int: bal_y = -2;          % 5*X - 2*Y <= 10000
int: max_bal = 10000;

int: cost_x = 200;
int: cost_y = 150;

% Decision variables: dollars allocated to channels X and Y
var 0..max_budget: x;
var 0..max_budget: y;

% Constraints
constraint x + y <= max_budget;
constraint eff_x * x + eff_y * y >= min_eff;
constraint bal_x * x + bal_y * y <= max_bal;

% Objective: minimize total cost
var int: total_cost = cost_x * x + cost_y * y;
solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_budget = ", show(x + y), "\n",
  "effectiveness = ", show(eff_x*x + eff_y*y), "\n",
  "balance_expr = ", show(bal_x*x - 2*y), "\n",
  "total_cost = ", show(total_cost), "\n"
];