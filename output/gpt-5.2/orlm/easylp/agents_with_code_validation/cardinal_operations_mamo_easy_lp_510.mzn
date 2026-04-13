% Parameters
int: cost_steel   = 10;    % $ per unit of steel
int: cost_wood    = 15;    % $ per unit of wood
int: cost_plastic = 20;    % $ per unit of plastic

int: min_2steel_plus_wood      = 1000; % 2*steel + wood >= 1000
int: max_steel_plus_plastic    = 2000; % steel + plastic <= 2000
int: min_wood_minus_plastic    = 500;  % wood - plastic >= 500
int: total_units               = 3500; % steel + wood + plastic == 3500

% Variables
var 0..total_units: steel;    % units of steel (integer, nonnegative)
var 0..total_units: wood;     % units of wood (integer, nonnegative)
var 0..total_units: plastic;  % units of plastic (integer, nonnegative)

% Total cost upper bound: all units at the highest material cost
var 0..(cost_steel*total_units + cost_wood*total_units + cost_plastic*total_units): total_cost;

% Constraints
% Material requirement: 2*steel + wood must be at least the minimum threshold
constraint 2 * steel + wood >= min_2steel_plus_wood;

% Availability/capacity limit: steel + plastic cannot exceed the maximum allowed
constraint steel + plastic <= max_steel_plus_plastic;

% Difference requirement: wood must exceed plastic by at least the minimum difference
constraint wood - plastic >= min_wood_minus_plastic;

% Total production balance: total units across all materials must equal the required total
constraint steel + wood + plastic = total_units;

% Cost accounting: define total_cost from per-unit costs and chosen quantities
constraint total_cost = cost_steel * steel + cost_wood * wood + cost_plastic * plastic;

% Objective
solve minimize total_cost;