% Parameters
int: unit_cost_X = 2;            % Unit cost for product X ($/unit)
int: unit_cost_Y = 3;            % Unit cost for product Y ($/unit)
int: max_total_units = 1000;     % Storage capacity (max total units)
int: min_units_X = 200;          % Minimum required units of X
int: min_units_Y = 300;          % Minimum required units of Y

% Variables
var min_units_X..max_total_units: units_X;   % Integer units of product X to order
var min_units_Y..max_total_units: units_Y;   % Integer units of product Y to order
var 0..(unit_cost_X*max_total_units + unit_cost_Y*max_total_units): total_cost; % Total ordering cost

% Constraints
% Storage capacity constraint: total ordered units cannot exceed available storage
constraint units_X + units_Y <= max_total_units;

% Cost definition constraint: total cost is the sum of unit costs times ordered units
constraint total_cost = unit_cost_X * units_X + unit_cost_Y * units_Y;

% Objective
solve minimize total_cost;