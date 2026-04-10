% Parameters
int: cost_per_unit_X = 5000;          % Cost per unit allocated to Project X ($)
int: cost_per_unit_Y = 8000;          % Cost per unit allocated to Project Y ($)
int: max_total_units = 100;           % Upper bound on X + Y
int: min_diff_X_over_Y = 20;          % Lower bound on X - Y (X at least 20 more than Y)
int: max_weighted_units = 150;        % Upper bound on X + 2*Y

% Variables
var 0..max_total_units: X;            % Integer units allocated to Project X
var 0..max_total_units: Y;            % Integer units allocated to Project Y
var 0..(cost_per_unit_X*max_total_units + cost_per_unit_Y*max_total_units): total_cost; % Total cost ($)

% Constraints
% Link total_cost to decision variables (cost accounting)
constraint
  total_cost = cost_per_unit_X * X + cost_per_unit_Y * Y;

% Total resource availability limit
constraint
  X + Y <= max_total_units;

% Diversification / balance constraint: X at least 20 more than Y
constraint
  X - Y >= min_diff_X_over_Y;

% Broader portfolio (weighted) resource limit
constraint
  X + 2 * Y <= max_weighted_units;

% Objective
solve minimize total_cost;