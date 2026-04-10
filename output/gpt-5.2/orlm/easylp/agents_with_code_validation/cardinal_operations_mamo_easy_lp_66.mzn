% Parameters
int: min_total_allocation = 100;          % Minimum required combined allocation (X + Y)
int: coeff_x = 5;                         % Coefficient for X in strategy constraint
int: coeff_y = -2;                        % Coefficient for Y in strategy constraint (5*X - 2*Y)
int: max_strategy_value = 50;             % Upper bound for strategy constraint value
int: cost_per_unit_x = 10;                % Cost per unit allocated to project X (dollars)
int: cost_per_unit_y = 20;                % Cost per unit allocated to project Y (dollars)

% Variables
var 0..min_total_allocation: x;           % Units allocated to project X
var 0..min_total_allocation: y;           % Units allocated to project Y
var 0..(cost_per_unit_y * min_total_allocation): total_cost; % Total cost (dollars)

% Constraints
% --- Minimum combined resource allocation ---
constraint
  x + y >= min_total_allocation;

% --- Resource distribution strategy constraint: 5*X - 2*Y <= 50 ---
constraint
  coeff_x * x + coeff_y * y <= max_strategy_value;

% --- Total cost computation ---
constraint
  total_cost = cost_per_unit_x * x + cost_per_unit_y * y;

% Objective
solve minimize total_cost;