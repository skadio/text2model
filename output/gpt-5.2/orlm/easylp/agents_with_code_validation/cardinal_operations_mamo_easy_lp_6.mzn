% Parameters
int: cost_x = 5;                 % Cost per unit for channel X
int: cost_y = 3;                 % Cost per unit for channel Y
int: min_total_effect = 1000;    % Minimum required total effectiveness (X + Y)
int: max_balance_diff = 500;     % Maximum allowed |X - 2*Y|

% Variables
var 0..min_total_effect + max_balance_diff: x_units;  % Units allocated to channel X (non-negative integer)
var 0..min_total_effect + max_balance_diff: y_units;  % Units allocated to channel Y (non-negative integer)

% Upper bound is a safe linear bound based on variable domains
var 0..(cost_x + cost_y) * (min_total_effect + max_balance_diff): total_cost; % Total cost to minimize

% Constraints
% Link total_cost to decision variables (linear cost calculation)
constraint
  total_cost = cost_x * x_units + cost_y * y_units;

% Minimum total effectiveness requirement
constraint
  x_units + y_units >= min_total_effect;

% Balance constraint: difference between X and twice Y must not exceed max_balance_diff
constraint
  abs(x_units - 2 * y_units) <= max_balance_diff;

% Objective
solve minimize total_cost;