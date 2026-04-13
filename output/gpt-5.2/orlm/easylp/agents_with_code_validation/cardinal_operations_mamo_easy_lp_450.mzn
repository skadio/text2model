% Parameters
% Planting cost per acre (USD)
int: cost_x = 100;
int: cost_y = 50;

% Fertilizer use per acre (units)
int: fert_x = 3;
int: fert_y = 2;

% Resource and policy limits
int: fert_limit = 1000;     % maximum total fertilizer units
int: min_total_acres = 200; % minimum combined acreage
int: max_diff_acres = 300;  % maximum allowed absolute difference in acres

% Maximum acreages due to suitability constraints
int: max_acres_x = 500;
int: max_acres_y = 400;

% Variables
% Acres planted (integer and within suitability bounds)
var 0..max_acres_x: acres_x;
var 0..max_acres_y: acres_y;

% Total cost (USD)
var 0..(cost_x * max_acres_x + cost_y * max_acres_y): total_cost;

% Constraints
% Link total_cost to planting decisions
constraint
  total_cost = cost_x * acres_x + cost_y * acres_y;

% Fertilizer usage must not exceed the available limit
constraint
  fert_x * acres_x + fert_y * acres_y <= fert_limit;

% Minimum total acreage requirement
constraint
  acres_x + acres_y >= min_total_acres;

% Diversity requirement: absolute difference in acreages is bounded
constraint
  abs(acres_x - acres_y) <= max_diff_acres;

% Objective
solve minimize total_cost;