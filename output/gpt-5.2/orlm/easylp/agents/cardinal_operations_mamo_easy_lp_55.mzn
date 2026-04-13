% Parameters
int: max_inventory = 5000;          % Storage limit on total units of X and Y
int: demand_min = 3000;             % Minimum required demand expression value: 2*X + 3*Y >= 3000
int: balance_max = 2000;            % Balance constraint upper bound: 5*X - Y <= 2000
int: cost_x = 20;                   % Cost per unit of product X (dollars)
int: cost_y = 10;                   % Cost per unit of product Y (dollars)

% Variables
var 0..max_inventory: x_units;      % Units of product X (non-negative integer)
var 0..max_inventory: y_units;      % Units of product Y (non-negative integer)
var 0..(cost_x*max_inventory + cost_y*max_inventory): total_cost; % Total cost in dollars (integer)

% Constraints

% Total cost definition
constraint total_cost = cost_x * x_units + cost_y * y_units;

% Storage capacity constraint: combined inventory cannot exceed max_inventory
constraint x_units + y_units <= max_inventory;

% Demand satisfaction constraint: ensure sufficient total demand coverage
constraint 2 * x_units + 3 * y_units >= demand_min;

% Inventory balance constraint: prevent excessive imbalance between X and Y
constraint 5 * x_units - y_units <= balance_max;

% Objective
solve minimize total_cost;