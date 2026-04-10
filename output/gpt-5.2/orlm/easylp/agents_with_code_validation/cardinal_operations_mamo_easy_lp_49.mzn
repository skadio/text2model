% Parameters
int: max_total_resources = 50;          % Budget cap: X + Y <= 50
int: min_effectiveness = 30;            % Requirement: 2*X + Y >= 30
int: max_balance_diff = 10;             % Balance: |X - 2*Y| <= 10

int: cost_per_x = 5;                    % Cost per unit of X
int: cost_per_y = 10;                   % Cost per unit of Y

% Derived bounds for decision variables (non-negative, plus implied upper bounds)
int: x_ub = max_total_resources;        % Since X <= X+Y <= 50
int: y_ub = max_total_resources;        % Since Y <= X+Y <= 50


% Variables
var 0..x_ub: x;                         % Integer resources allocated to service X
var 0..y_ub: y;                         % Integer resources allocated to service Y

var 0..(cost_per_x * x_ub + cost_per_y * y_ub): total_cost;  % Total cost to minimize


% Constraints
% Total resource budget constraint: X + Y <= 50
constraint x + y <= max_total_resources;

% Minimum effectiveness constraint: 2*X + Y >= 30
constraint 2 * x + y >= min_effectiveness;

% Balance constraint: |X - 2*Y| <= 10
constraint abs(x - 2 * y) <= max_balance_diff;

% Define total cost from allocations
constraint total_cost = cost_per_x * x + cost_per_y * y;


% Objective
solve minimize total_cost;