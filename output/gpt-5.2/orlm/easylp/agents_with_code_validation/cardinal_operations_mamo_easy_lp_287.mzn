% Parameters
% Total available budget (sum of investments across all projects)
int: total_budget = 300;

% Minimum required investments for each project
int: min_invest_X = 80;
int: min_invest_Y = 60;
int: min_invest_Z = 40;

% Cost per unit invested in each project
int: cost_X = 50;
int: cost_Y = 70;
int: cost_Z = 100;

% Variables
% Whole-number investment amounts in each project, bounded by min requirements and total budget
var min_invest_X..total_budget: invest_X;
var min_invest_Y..total_budget: invest_Y;
var min_invest_Z..total_budget: invest_Z;

% Total cost (bounded using the maximum possible spend within the budget)
var 0..(total_budget * max([cost_X, cost_Y, cost_Z])): total_cost;

% Constraints
% Budget constraint: total investment across X, Y, Z cannot exceed the available budget
constraint
  invest_X + invest_Y + invest_Z <= total_budget;

% Total cost definition: compute total_cost from per-unit costs and investment decisions
constraint
  total_cost = cost_X * invest_X + cost_Y * invest_Y + cost_Z * invest_Z;

% Objective
solve minimize total_cost;

% Optional output for clarity
output [
  "invest_X=", show(invest_X), "\n",
  "invest_Y=", show(invest_Y), "\n",
  "invest_Z=", show(invest_Z), "\n",
  "total_cost=", show(total_cost), "\n"
];