% Parameters
int: max_total_items = 1000;              % Storage capacity limit: X + Y <= 1000
int: min_weighted_balance = 500;          % Balance requirement: 2*X + Y >= 500
int: max_difference = 200;                % Inventory balance: |X - 2*Y| <= 200
int: cost_x = 5;                          % Cost per unit of product X ($)
int: cost_y = 10;                         % Cost per unit of product Y ($)

% Variables
var 0..max_total_items: x_qty;            % Quantity of product X (integer, non-negative)
var 0..max_total_items: y_qty;            % Quantity of product Y (integer, non-negative)
var 0..(cost_x*max_total_items + cost_y*max_total_items): total_cost; % Total stocking cost ($)

% Constraints
% Total capacity constraint: cannot exceed storage limit
constraint
  x_qty + y_qty <= max_total_items;

% Weighted balance constraint: ensure sufficient combined presence of X and Y
constraint
  2 * x_qty + y_qty >= min_weighted_balance;

% Inventory difference constraint: keep X close to twice Y (within allowed deviation)
constraint
  abs(x_qty - 2 * y_qty) <= max_difference;

% Total cost definition: compute total stocking cost from quantities and unit costs
constraint
  total_cost = cost_x * x_qty + cost_y * y_qty;

% Objective
solve minimize total_cost;