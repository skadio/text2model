% Parameters
% Budget and cost parameters (all data embedded as required)
int: total_budget = 100;          % Maximum total investment allowed across both projects
int: min_invest_X = 30;           % Minimum viable investment in Project X
int: min_invest_Y = 20;           % Minimum viable investment in Project Y
int: unit_cost_X = 50;            % Cost per unit invested in Project X
int: unit_cost_Y = 60;            % Cost per unit invested in Project Y

% Variables
% Integer investments (whole-number units) with required minimums
var min_invest_X..total_budget: invest_X;
var min_invest_Y..total_budget: invest_Y;

% Total cost (bounded above by worst-case spending if both were at total_budget)
var 0..(unit_cost_X*total_budget + unit_cost_Y*total_budget): total_cost;

% Constraints
% Budget feasibility: total investment across both projects cannot exceed the allowed budget
constraint
  invest_X + invest_Y <= total_budget;

% Cost accounting: total cost is the sum of per-unit costs times investment in each project
constraint
  total_cost = unit_cost_X * invest_X + unit_cost_Y * invest_Y;

% Objective
solve minimize total_cost;

output [
  "invest_X=", show(invest_X), "\n",
  "invest_Y=", show(invest_Y), "\n",
  "total_cost=", show(total_cost), "\n"
];