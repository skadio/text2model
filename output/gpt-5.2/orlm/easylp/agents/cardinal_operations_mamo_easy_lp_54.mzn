% Parameters
% All data is embedded directly in the model (no .dzn expected).
int: min_inventory_score = 10;   % Minimum required inventory score: x + 3y >= 10
int: max_storage_limit   = 15;   % Maximum storage limit: 2x + y <= 15
int: cost_x = 4;                % Cost per unit of product X
int: cost_y = 5;                % Cost per unit of product Y

% Variables
var 0..max_storage_limit: x;     % Units of product X (non-negative integer)
var 0..max_storage_limit: y;     % Units of product Y (non-negative integer)
var 0..(cost_x*max_storage_limit + cost_y*max_storage_limit): total_cost; % Total cost

% Constraints
% Inventory score requirement (meet minimum demand)
constraint x + 3 * y >= min_inventory_score;

% Storage capacity limitation (do not exceed available storage)
constraint 2 * x + y <= max_storage_limit;

% Define total cost consistently with decision variables
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_cost = ", show(total_cost), "\n"
];