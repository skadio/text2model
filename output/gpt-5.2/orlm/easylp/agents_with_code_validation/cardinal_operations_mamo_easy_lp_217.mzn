% Parameters
int: total_budget_cap = 5000;          % Maximum total budget allowed ($)
int: cost_per_unit_X = 10;             % Cost per unit budget in department X ($/unit)
int: cost_per_unit_Y = 20;             % Cost per unit budget in department Y ($/unit)
int: cost_per_unit_Z = 30;             % Cost per unit budget in department Z ($/unit)

int: eff_units_X = 5;                  % Units of X considered in effectiveness constraint
int: eff_units_Y = 10;                 % Units of Y considered in effectiveness constraint
int: min_effectiveness = 10000;        % Minimum required effectiveness ($)

int: max_budget_diff_XZ = 1500;        % Maximum allowed absolute difference between X and Z budgets ($)

% Variables
var 0..total_budget_cap: budget_X;     % Allocated budget to department X ($)
var 0..total_budget_cap: budget_Y;     % Allocated budget to department Y ($)
var 0..total_budget_cap: budget_Z;     % Allocated budget to department Z ($)

% Upper bound: worst case if each budget hits total_budget_cap
var 0..(cost_per_unit_X * total_budget_cap
      + cost_per_unit_Y * total_budget_cap
      + cost_per_unit_Z * total_budget_cap): total_cost;  % Total cost to minimize ($)

% Constraints
% --- Total budget cap across all departments ---
constraint budget_X + budget_Y + budget_Z <= total_budget_cap;

% --- Effectiveness requirement (based on specified units of X and Y) ---
% 5 * budget_X + 10 * budget_Y must be at least 10000
constraint eff_units_X * budget_X + eff_units_Y * budget_Y >= min_effectiveness;

% --- Balance requirement between departments X and Z (absolute budget difference) ---
constraint abs(budget_X - budget_Z) <= max_budget_diff_XZ;

% --- Define total_cost from allocated budgets and per-unit costs ---
constraint total_cost = cost_per_unit_X * budget_X
                      + cost_per_unit_Y * budget_Y
                      + cost_per_unit_Z * budget_Z;

% Objective
solve minimize total_cost;