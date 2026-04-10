% MiniZinc model: Budget allocation among departments X, Y, Z

int: total_budget_cap = 5000;

int: costX = 10;
int: costY = 20;
int: costZ = 30;

int: revenue_requirement = 10000;

int: max_diff_XZ_budget = 1500;

% Decision variables: number of "units" of investment in each department (integers)
% Each unit corresponds to the given per-unit cost in dollars.
var 0..(total_budget_cap div costX): x;
var 0..(total_budget_cap div costY): y;
var 0..(total_budget_cap div costZ): z;

var 0..total_budget_cap: total_cost = costX*x + costY*y + costZ*z;

constraint total_cost <= total_budget_cap;

% Effectiveness (sales revenue) constraint:
% 5 units of X and 10 units of Y (per unit invested) must generate at least 10000.
constraint 5*x + 10*y >= revenue_requirement;

% Budget difference between X and Z (in dollars) should not exceed 1500.
constraint abs(costX*x - costZ*z) <= max_diff_XZ_budget;

solve minimize total_cost;

output [
  "x_units = ", show(x), "\n",
  "y_units = ", show(y), "\n",
  "z_units = ", show(z), "\n",
  "total_cost = $", show(total_cost), "\n"
];