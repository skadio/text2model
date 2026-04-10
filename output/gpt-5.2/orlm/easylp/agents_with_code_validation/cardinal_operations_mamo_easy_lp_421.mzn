% Parameters
int: total_allocation_max = 5000;   % Maximum total resource units available (budget/resource cap)
int: min_x = 1000;                  % Minimum units required for project X to be viable
int: min_y = 1500;                  % Minimum units required for project Y to be viable
int: cost_x = 100;                  % Cost per unit invested in project X (dollars/unit)
int: cost_y = 75;                   % Cost per unit invested in project Y (dollars/unit)

% Variables
var min_x..total_allocation_max: x_units;   % Units allocated to project X
var min_y..total_allocation_max: y_units;   % Units allocated to project Y
var 0..(cost_x * total_allocation_max + cost_y * total_allocation_max): total_cost; % Total cost

% Constraints
% Total allocation cap: combined resources across projects cannot exceed the maximum available
constraint x_units + y_units <= total_allocation_max;

% Total cost definition: compute total cost from per-unit costs and allocated units
constraint total_cost = cost_x * x_units + cost_y * y_units;

% Objective
solve minimize total_cost;