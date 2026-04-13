% Parameters
int: total_budget = 5000;              % Maximum total budget allocated across all projects (dollars)
int: min_invest_X = 1000;              % Minimum required investment in project X (dollars)
int: max_invest_Y = 3000;              % Maximum allowed investment in project Y (dollars)
int: min_invest_Z = 500;               % Minimum required investment in project Z (dollars)

int: cost_per_dollar_X = 100;          % Cost per dollar invested in project X
int: cost_per_dollar_Y = 200;          % Cost per dollar invested in project Y
int: cost_per_dollar_Z = 50;           % Cost per dollar invested in project Z

% Variables
var 0..total_budget: invest_X;         % Dollars allocated to project X
var 0..total_budget: invest_Y;         % Dollars allocated to project Y
var 0..total_budget: invest_Z;         % Dollars allocated to project Z

var int: total_cost;                   % Total cost (dollars) to be minimized

% Constraints
% Budget feasibility: total allocated budget across projects must not exceed the available budget
constraint
  invest_X + invest_Y + invest_Z <= total_budget;

% Project viability / regulatory limits: enforce minimum and maximum investments per project
constraint invest_X >= min_invest_X;   % Project X minimum investment
constraint invest_Y <= max_invest_Y;   % Project Y maximum investment
constraint invest_Z >= min_invest_Z;   % Project Z minimum investment

% Total cost definition: compute total cost from per-dollar costs and investments
constraint
  total_cost =
    cost_per_dollar_X * invest_X +
    cost_per_dollar_Y * invest_Y +
    cost_per_dollar_Z * invest_Z;

% Objective
solve minimize total_cost;