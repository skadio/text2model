% Parameters
int: cost_x = 100;              % Cost per acre for crop X (dollars)
int: cost_y = 50;               % Cost per acre for crop Y (dollars)

int: fert_per_acre_x = 3;       % Fertilizer units per acre for crop X
int: fert_per_acre_y = 2;       % Fertilizer units per acre for crop Y
int: fert_capacity = 1000;      % Maximum available fertilizer units

int: min_total_acres = 200;     % Minimum combined acreage of both crops
int: max_diff_acres = 300;      % Maximum allowed absolute difference in acres

int: max_acres_x = 500;         % Maximum acres allowed for crop X
int: max_acres_y = 400;         % Maximum acres allowed for crop Y

% Variables
var 0..max_acres_x: acres_x;    % Integer acres planted with crop X
var 0..max_acres_y: acres_y;    % Integer acres planted with crop Y

var 0..(cost_x*max_acres_x + cost_y*max_acres_y): total_cost; % Total planting cost (dollars)

% Constraints
% Link total_cost to the planted acreage decisions
constraint total_cost = cost_x * acres_x + cost_y * acres_y;

% Fertilizer capacity constraint (total fertilizer used cannot exceed available capacity)
constraint fert_per_acre_x * acres_x + fert_per_acre_y * acres_y <= fert_capacity;

% Minimum total acreage constraint (ensure efficient use of farmland)
constraint acres_x + acres_y >= min_total_acres;

% Diversity constraint (absolute difference in acreage between crops limited)
constraint abs(acres_x - acres_y) <= max_diff_acres;

% Objective
solve minimize total_cost;