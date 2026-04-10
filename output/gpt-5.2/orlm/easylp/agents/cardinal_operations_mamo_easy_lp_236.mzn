% Parameters
% Planting costs per acre (USD)
int: cost_wheat = 20;
int: cost_corn  = 30;
int: cost_soy   = 10;

% Constraint limits (acres)
int: max_wheat_plus_corn = 200;      % wheat + corn <= 200
int: min_2wheat_plus_soy = 150;      % 2*wheat + soy >= 150
int: max_corn_minus_soy  = 100;      % |corn - soy| <= 100


% Variables
% Acres planted with each crop (integer, nonnegative)
var 0..max_wheat_plus_corn: acres_wheat;
var 0..max_wheat_plus_corn: acres_corn;
var 0..max_wheat_plus_corn: acres_soy;

% Total cost (USD)
var 0..(cost_wheat*max_wheat_plus_corn + cost_corn*max_wheat_plus_corn + cost_soy*max_wheat_plus_corn): total_cost;


% Constraints
% Total planting area limitation: wheat + corn cannot exceed available space
constraint
  acres_wheat + acres_corn <= max_wheat_plus_corn;

% Crop rotation requirement: twice wheat plus soybeans must be at least the minimum
constraint
  2 * acres_wheat + acres_soy >= min_2wheat_plus_soy;

% Balance constraint: corn and soybeans acreage difference cannot exceed the limit
constraint
  abs(acres_corn - acres_soy) <= max_corn_minus_soy;

% Total cost definition from per-acre costs and planted acres
constraint
  total_cost =
    cost_wheat * acres_wheat +
    cost_corn  * acres_corn +
    cost_soy   * acres_soy;


% Objective
solve minimize total_cost;