% Parameters
int: max_total_items = 1000;                 % Storage capacity limit
int: min_weighted_balance = 500;             % Minimum required: 2*X + Y
int: max_diff_limit = 200;                   % Maximum allowed: |X - 2*Y|
int: cost_x = 5;                             % Cost per unit of product X ($)
int: cost_y = 10;                            % Cost per unit of product Y ($)

% Variables
var 0..max_total_items: x_qty;               % Number of units of product X
var 0..max_total_items: y_qty;               % Number of units of product Y
var 0..(cost_x*max_total_items + cost_y*max_total_items): total_cost; % Total cost ($)

% Constraints
% Link total_cost to decision variables (cost accounting)
constraint
  total_cost = cost_x * x_qty + cost_y * y_qty;

% Storage capacity constraint: total items cannot exceed capacity
constraint
  x_qty + y_qty <= max_total_items;

% Balanced offering constraint: ensure sufficient weighted mix (2*X + Y >= threshold)
constraint
  2 * x_qty + y_qty >= min_weighted_balance;

% Inventory balance constraint: difference between X and twice Y is bounded
constraint
  abs(x_qty - 2 * y_qty) <= max_diff_limit;

% Objective
solve minimize total_cost;