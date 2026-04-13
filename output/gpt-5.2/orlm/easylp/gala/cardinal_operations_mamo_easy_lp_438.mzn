% Hospital budget allocation between two departments
% All data embedded as requested.

int: total_budget_max = 200;
int: min_x = 50;
int: min_y = 30;

int: cost_x = 5000;   % dollars per unit for Department X
int: cost_y = 8000;   % dollars per unit for Department Y

var min_x..total_budget_max: x;   % units allocated to Department X
var min_y..total_budget_max: y;   % units allocated to Department Y

constraint x + y <= total_budget_max;

var int: total_cost = cost_x * x + cost_y * y;

solve minimize total_cost;

output [
  "DepartmentX_units = ", show(x), "\n",
  "DepartmentY_units = ", show(y), "\n",
  "MinTotalExpenditureUSD = ", show(total_cost), "\n"
];