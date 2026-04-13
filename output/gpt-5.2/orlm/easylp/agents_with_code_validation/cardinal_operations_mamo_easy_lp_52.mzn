% Parameters
int: unit_cost_X = 2;                 % Unit cost of product X ($/unit)
int: unit_cost_Y = 3;                 % Unit cost of product Y ($/unit)
int: storage_capacity = 1000;         % Maximum total units that can be ordered
int: min_units_X = 200;               % Minimum units of product X to order
int: min_units_Y = 300;               % Minimum units of product Y to order

% Variables
var min_units_X..storage_capacity: units_X;  % Integer units of product X to order
var min_units_Y..storage_capacity: units_Y;  % Integer units of product Y to order

% Total ordering cost ($), bounded by the maximum possible cost at full capacity for both
var 0..(unit_cost_X * storage_capacity + unit_cost_Y * storage_capacity): total_cost;

% Constraints
% Storage capacity constraint: total ordered units cannot exceed available capacity
constraint
  units_X + units_Y <= storage_capacity;

% Minimum order quantities (redundant with variable domains, kept for clarity/maintenance)
constraint
  units_X >= min_units_X;

constraint
  units_Y >= min_units_Y;

% Total cost definition: compute ordering cost from unit costs and quantities
constraint
  total_cost = unit_cost_X * units_X + unit_cost_Y * units_Y;

% Objective
solve minimize total_cost;