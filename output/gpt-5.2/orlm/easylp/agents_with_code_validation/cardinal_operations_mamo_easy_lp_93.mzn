% Parameters
int: capacity_total = 1000;          % Maximum total units distributed to both warehouses
int: demand_min = 800;              % Minimum required for (2*X + Y)
int: balance_max_diff = 200;        % Maximum allowed for |X - 2*Y|
int: cost_per_unit_X = 2;           % Cost per unit sent to warehouse X
int: cost_per_unit_Y = 3;           % Cost per unit sent to warehouse Y

% Variables
var 0..capacity_total: x_units;     % Integer units distributed to warehouse X
var 0..capacity_total: y_units;     % Integer units distributed to warehouse Y
var 0..(cost_per_unit_X*capacity_total + cost_per_unit_Y*capacity_total): total_cost; % Total cost (bounded)

% Constraints
% --- Capacity constraint: total distribution cannot exceed overall capacity ---
constraint
  x_units + y_units <= capacity_total;

% --- Demand constraint: ensure minimum combined effective supply (2*X + Y) ---
constraint
  2 * x_units + y_units >= demand_min;

% --- Balance constraint: keep inventories balanced ---
constraint
  abs(x_units - 2 * y_units) <= balance_max_diff;

% --- Total cost definition ---
constraint
  total_cost = cost_per_unit_X * x_units + cost_per_unit_Y * y_units;

% Objective
solve minimize total_cost;