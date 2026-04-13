% Parameters
int: budget = 1000;                 % Maximum total investment allowed
int: min_invest_X = 200;            % Minimum viable investment in asset X
int: min_invest_Y = 150;            % Minimum viable investment in asset Y
int: min_invest_Z = 250;            % Minimum viable investment in asset Z

int: cost_per_unit_X = 500;         % Cost per unit invested in asset X
int: cost_per_unit_Y = 300;         % Cost per unit invested in asset Y
int: cost_per_unit_Z = 700;         % Cost per unit invested in asset Z

% Variables
var min_invest_X..budget: invest_X; % Integer investment amount in asset X (meets minimum)
var min_invest_Y..budget: invest_Y; % Integer investment amount in asset Y (meets minimum)
var min_invest_Z..budget: invest_Z; % Integer investment amount in asset Z (meets minimum)

int: max_cost_per_unit = max([cost_per_unit_X, cost_per_unit_Y, cost_per_unit_Z]);
var 0..(budget * max_cost_per_unit): total_cost; % Total cost to minimize

% Constraints
% Budget constraint: total investment across assets cannot exceed the budget
constraint
  invest_X + invest_Y + invest_Z <= budget;

% Total cost definition: sum of (investment * cost per unit) across all assets
constraint
  total_cost =
    invest_X * cost_per_unit_X +
    invest_Y * cost_per_unit_Y +
    invest_Z * cost_per_unit_Z;

% Objective
solve minimize total_cost;