% Parameters
int: max_total_capacity = 1000;        % Maximum total units distributed to X and Y
int: min_demand = 800;                % Minimum required for (2*X + Y)
int: max_imbalance = 200;             % Maximum allowed for |X - 2*Y|
int: cost_per_unit_X = 2;             % Cost per unit to warehouse X
int: cost_per_unit_Y = 3;             % Cost per unit to warehouse Y

% Variables
var 0..max_total_capacity: x_units;    % Units distributed to warehouse X (non-negative integer)
var 0..max_total_capacity: y_units;    % Units distributed to warehouse Y (non-negative integer)
var int: total_cost;                  % Total distribution cost (in dollars, integer)

% Constraints
% Capacity constraint: total units sent to both warehouses cannot exceed capacity
constraint
  x_units + y_units <= max_total_capacity;

% Demand constraint: ensure sufficient supply according to required weighted sum
constraint
  2 * x_units + y_units >= min_demand;

% Balance/imbalance constraint: keep inventory difference within allowed limit
constraint
  abs(x_units - 2 * y_units) <= max_imbalance;

% Total cost definition: compute total distribution cost from unit costs
constraint
  total_cost = cost_per_unit_X * x_units + cost_per_unit_Y * y_units;

% Objective
solve minimize total_cost;