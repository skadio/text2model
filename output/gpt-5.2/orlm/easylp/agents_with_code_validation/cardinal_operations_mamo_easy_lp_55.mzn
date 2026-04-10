% Parameters
int: max_total_inventory = 5000;         % Storage capacity: x + y <= 5000
int: min_demand = 3000;                  % Demand requirement: 2x + 3y >= 3000
int: balance_limit = 2000;               % Balance constraint: 5x - y <= 2000
int: cost_x = 20;                        % Unit cost of product X
int: cost_y = 10;                        % Unit cost of product Y

% Variables
var 0..max_total_inventory: x_units;     % Units of product X (non-negative integer)
var 0..max_total_inventory: y_units;     % Units of product Y (non-negative integer)

var 0..(cost_x * max_total_inventory + cost_y * max_total_inventory): total_cost;
                                         % Total cost (bounded for safe linear use)

% Constraints
% Total inventory storage capacity
constraint x_units + y_units <= max_total_inventory;

% Minimum demand satisfaction requirement
constraint 2 * x_units + 3 * y_units >= min_demand;

% Inventory balance/relationship constraint
constraint 5 * x_units - y_units <= balance_limit;

% Define total cost from unit costs and quantities
constraint total_cost = cost_x * x_units + cost_y * y_units;

% Objective
solve minimize total_cost;