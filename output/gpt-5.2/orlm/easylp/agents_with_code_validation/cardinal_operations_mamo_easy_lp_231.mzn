% Parameters
int: max_acres = 1000;                 % Total land available (acres)

int: min_acres_X = 200;                % Minimum acres for crop X
int: min_acres_Y = 150;                % Minimum acres for crop Y
int: min_acres_Z = 100;                % Minimum acres for crop Z

int: cost_per_acre_X = 10;             % Cost per acre for crop X ($/acre)
int: cost_per_acre_Y = 20;             % Cost per acre for crop Y ($/acre)
int: cost_per_acre_Z = 30;             % Cost per acre for crop Z ($/acre)

% Variables
var 0..max_acres: acres_X;             % Acres planted with crop X (whole number)
var 0..max_acres: acres_Y;             % Acres planted with crop Y (whole number)
var 0..max_acres: acres_Z;             % Acres planted with crop Z (whole number)

% Upper bound: put all acres in the most expensive crop (safe bound)
var 0..(max_acres * max(cost_per_acre_X, max(cost_per_acre_Y, cost_per_acre_Z))): total_cost;

% Constraints
% Acreage lower bounds (minimum required planting per crop)
constraint acres_X >= min_acres_X;
constraint acres_Y >= min_acres_Y;
constraint acres_Z >= min_acres_Z;

% Total land availability (cannot exceed maximum acres)
constraint acres_X + acres_Y + acres_Z <= max_acres;

% Total cost definition (integer dollars)
constraint total_cost
  = cost_per_acre_X * acres_X
  + cost_per_acre_Y * acres_Y
  + cost_per_acre_Z * acres_Z;

% Objective
solve minimize total_cost;