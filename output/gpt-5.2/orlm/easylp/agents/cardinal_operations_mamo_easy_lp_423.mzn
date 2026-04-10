% Parameters
int: max_total_units = 5000;          % Maximum combined production capacity
int: min_steel_units = 1000;          % Minimum required Steel units
int: min_aluminum_units = 2000;       % Minimum required Aluminum units
int: cost_per_steel = 20;             % Cost per unit of Steel ($)
int: cost_per_aluminum = 30;          % Cost per unit of Aluminum ($)

% Variables
var min_steel_units..max_total_units: steel_units;        % Units of Steel produced (integer)
var min_aluminum_units..max_total_units: aluminum_units;  % Units of Aluminum produced (integer)
var 0..(max_total_units * max(cost_per_steel, cost_per_aluminum)): total_cost; % Total cost ($)

% Constraints
% Production capacity constraint (combined units cannot exceed total capacity)
constraint
  steel_units + aluminum_units <= max_total_units;

% Total cost calculation constraint (link total_cost to unit productions and costs)
constraint
  total_cost = cost_per_steel * steel_units + cost_per_aluminum * aluminum_units;

% Objective
solve minimize total_cost;