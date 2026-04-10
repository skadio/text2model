% Parameters
int: total_shelf_space = 2000;          % Total shelf space available (units)
int: min_demand = 500;                  % Minimum demand requirement for 2*X + Y (units)
int: max_balance_diff = 1000;           % Maximum allowed |X - 2*Y| (units)

int: cost_per_unit_x = 2;               % Cost per unit shelf space for product X ($/unit)
int: cost_per_unit_y = 3;               % Cost per unit shelf space for product Y ($/unit)

% Variables
var 0..total_shelf_space: shelf_x;      % Shelf space allocated to product X (units, integer)
var 0..total_shelf_space: shelf_y;      % Shelf space allocated to product Y (units, integer)
var int: total_cost;                    % Total cost ($), to be minimized

% Constraints
% Total shelf space capacity: X + Y <= total_shelf_space
constraint shelf_x + shelf_y <= total_shelf_space;

% Minimum demand requirement: 2*X + Y >= min_demand
constraint 2 * shelf_x + shelf_y >= min_demand;

% Balance requirement: |X - 2*Y| <= max_balance_diff
constraint abs(shelf_x - 2 * shelf_y) <= max_balance_diff;

% Total cost definition
constraint total_cost = cost_per_unit_x * shelf_x + cost_per_unit_y * shelf_y;

% Objective
solve minimize total_cost;

% Optional output for clarity
output [
  "shelf_x = ", show(shelf_x), "\n",
  "shelf_y = ", show(shelf_y), "\n",
  "total_cost = ", show(total_cost), "\n"
];