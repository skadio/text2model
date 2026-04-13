% Parameters
int: max_total_units = 100;          % Maximum total resources available for X+Y
int: min_total_units = 30;           % Minimum total resources required for X+Y
int: min_effectiveness = 0;          % Minimum required effectiveness score
int: eff_x = 2;                      % Effectiveness coefficient for X
int: eff_y = 3;                      % Effectiveness coefficient for Y
int: cost_x = 4;                     % Cost per unit of X (dollars)
int: cost_y = 5;                     % Cost per unit of Y (dollars)

% Variables
var 0..max_total_units: x_units;     % Integer units allocated to initiative X
var 0..max_total_units: y_units;     % Integer units allocated to initiative Y
var 0..(cost_x*max_total_units + cost_y*max_total_units): total_cost; % Total cost (dollars)

% Constraints
% Resource capacity constraints: total units must be within [min_total_units, max_total_units]
constraint x_units + y_units <= max_total_units;
constraint x_units + y_units >= min_total_units;

% Effectiveness requirement: 2*x + 3*y must meet the minimum effectiveness score
constraint eff_x * x_units + eff_y * y_units >= min_effectiveness;

% Total cost definition: link total_cost to chosen allocations
constraint total_cost = cost_x * x_units + cost_y * y_units;

% Objective
solve minimize total_cost;