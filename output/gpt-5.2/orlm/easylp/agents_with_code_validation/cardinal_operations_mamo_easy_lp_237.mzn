% Parameters
% Per-acre cultivation costs (units per acre)
int: cost_wheat = 5;
int: cost_corn  = 4;
int: cost_soy   = 6;

% Constraint right-hand sides
int: max_soil_1 = 50;  % for: 2*wheat + corn <= 50
int: max_soil_2 = 60;  % for: wheat + 3*soy <= 60
int: min_market = 30;  % for: corn + soy >= 30


% Variables
% Acres allocated to each crop (whole acres, nonnegative)
% Upper bound uses the maximum RHS among the soil constraints.
var 0..max(max_soil_1, max_soil_2): acres_wheat;
var 0..max(max_soil_1, max_soil_2): acres_corn;
var 0..max(max_soil_1, max_soil_2): acres_soy;

% Total cost (bounded explicitly for use in objective/linear expressions)
var 0..(cost_wheat + cost_corn + cost_soy) * max(max_soil_1, max_soil_2): total_cost;


% Constraints
% Soil quality restriction 1: 2*wheat + corn <= 50
constraint
  2 * acres_wheat + acres_corn <= max_soil_1;

% Soil quality restriction 2: wheat + 3*soy <= 60
constraint
  acres_wheat + 3 * acres_soy <= max_soil_2;

% Market demand restriction: corn + soy >= 30
constraint
  acres_corn + acres_soy >= min_market;

% Define total cultivation cost from per-acre costs
constraint
  total_cost = cost_wheat * acres_wheat
             + cost_corn  * acres_corn
             + cost_soy   * acres_soy;


% Objective
solve minimize total_cost;