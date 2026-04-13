% Marketing budget allocation (integer investments)

int: total_budget = 2000;

int: cost_X1 = 1000;
int: cost_X2 = 500;

int: max_invest_X1_dollars = 1500;
int: max_invest_X2_dollars = 1000;

% Decision variables: number of investment units (must be whole numbers)
% Each unit costs cost_X1 or cost_X2 dollars respectively.
var 0..(max_invest_X1_dollars div cost_X1): x1;
var 0..(max_invest_X2_dollars div cost_X2): x2;

% Total cost in dollars
var int: total_cost = cost_X1 * x1 + cost_X2 * x2;

constraint total_cost <= total_budget;

% Constraints (interpreted on dollar allocations to each campaign)
% Let budget_X1 = cost_X1*x1, budget_X2 = cost_X2*x2
constraint 3 * (cost_X1 * x1) - (cost_X2 * x2) >= 500;
constraint (cost_X1 * x1) - 2 * (cost_X2 * x2) <= 800;

solve minimize total_cost;

output [
  "x1_units = ", show(x1), "\n",
  "x2_units = ", show(x2), "\n",
  "total_cost_dollars = ", show(total_cost), "\n"
];