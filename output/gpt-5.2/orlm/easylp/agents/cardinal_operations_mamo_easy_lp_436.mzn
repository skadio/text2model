% Parameters
int: min_budget_X = 200;          % minimum budget for department X ($)
int: min_budget_Y = 100;          % minimum budget for department Y ($)
int: max_total_budget = 1000;     % maximum combined budget ($)
int: cost_per_unit_X = 50;        % cost per unit allocated to X ($/unit)
int: cost_per_unit_Y = 80;        % cost per unit allocated to Y ($/unit)

% Variables
var 0..(max_total_budget div cost_per_unit_X): units_X; % units allocated to X (bounded, non-negative)
var 0..(max_total_budget div cost_per_unit_Y): units_Y; % units allocated to Y (bounded, non-negative)
var 0..max_total_budget: budget_X;                      % budget allocated to X ($)
var 0..max_total_budget: budget_Y;                      % budget allocated to Y ($)
var 0..max_total_budget: total_budget;                  % total allocated budget ($)
var 0..(max_total_budget * 2): total_cost;              % total cost to minimize ($), safe upper bound

% Constraints
% Link allocated units to their corresponding budgets (linear scaling)
constraint budget_X = cost_per_unit_X * units_X;
constraint budget_Y = cost_per_unit_Y * units_Y;

% Enforce minimum budget requirements for each department
constraint budget_X >= min_budget_X;
constraint budget_Y >= min_budget_Y;

% Compute and limit the total allocated budget
constraint total_budget = budget_X + budget_Y;
constraint total_budget <= max_total_budget;

% Compute total cost from the allocated units
constraint total_cost = cost_per_unit_X * units_X + cost_per_unit_Y * units_Y;

% Objective
solve minimize total_cost;