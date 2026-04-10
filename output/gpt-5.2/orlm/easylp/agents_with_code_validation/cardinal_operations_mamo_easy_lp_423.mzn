% Parameters
int: max_total_units = 5000;          % Maximum total production capacity (units)
int: min_steel_units = 1000;          % Minimum required Steel production (units)
int: min_aluminum_units = 2000;       % Minimum required Aluminum production (units)
int: cost_per_steel = 20;             % Cost per unit of Steel ($/unit)
int: cost_per_aluminum = 30;          % Cost per unit of Aluminum ($/unit)

% Variables
var 0..max_total_units: steel_units;    % Number of Steel units produced (integer units)
var 0..max_total_units: aluminum_units; % Number of Aluminum units produced (integer units)
var 0..(max_total_units * max(cost_per_steel, cost_per_aluminum)): total_cost; % Total cost ($)

% Constraints
% Production capacity constraint: total units cannot exceed maximum capacity
constraint
  steel_units + aluminum_units <= max_total_units;

% Minimum production requirements for each product type
constraint
  steel_units >= min_steel_units;

constraint
  aluminum_units >= min_aluminum_units;

% Total cost calculation constraint (link total_cost to decision variables)
constraint
  total_cost = cost_per_steel * steel_units + cost_per_aluminum * aluminum_units;

% Objective
solve minimize total_cost;