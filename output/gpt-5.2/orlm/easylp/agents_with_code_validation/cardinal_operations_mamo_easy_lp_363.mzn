% Parameters
% Cost per acre for each crop (in dollars)
int: cost_wheat = 2;
int: cost_corn = 3;
int: cost_soybeans = 1;
int: cost_potatoes = 4;

% Constraint thresholds (in acres)
int: min_wheat_plus_corn = 1000;
int: max_soybeans_plus_potatoes = 800;
int: min_wheat_minus_soybeans = 200;
int: max_corn_plus_potatoes = 500;

% Variables
% Acres planted for each crop (must be whole acres, non-negative)
var 0..1000000: acres_wheat;
var 0..1000000: acres_corn;
var 0..1000000: acres_soybeans;
var 0..1000000: acres_potatoes;

% Total cost (dollars), bounded non-negative
var 0..1000000000: total_cost;

% Constraints
% --- Area combination constraints (policy/feasibility requirements) ---

% Minimum combined acreage for wheat and corn
constraint acres_wheat + acres_corn >= min_wheat_plus_corn;

% Maximum combined acreage for soybeans and potatoes
constraint acres_soybeans + acres_potatoes <= max_soybeans_plus_potatoes;

% Wheat must exceed soybeans by at least a given margin
constraint acres_wheat - acres_soybeans >= min_wheat_minus_soybeans;

% Maximum combined acreage for corn and potatoes
constraint acres_corn + acres_potatoes <= max_corn_plus_potatoes;

% --- Total cost definition (linking variable) ---

% Define total planting cost from per-acre costs and acre decisions
constraint total_cost =
  cost_wheat * acres_wheat +
  cost_corn * acres_corn +
  cost_soybeans * acres_soybeans +
  cost_potatoes * acres_potatoes;

% Objective
solve minimize total_cost;

output [
  "acres_wheat=", show(acres_wheat), "\n",
  "acres_corn=", show(acres_corn), "\n",
  "acres_soybeans=", show(acres_soybeans), "\n",
  "acres_potatoes=", show(acres_potatoes), "\n",
  "total_cost=", show(total_cost), "\n"
];