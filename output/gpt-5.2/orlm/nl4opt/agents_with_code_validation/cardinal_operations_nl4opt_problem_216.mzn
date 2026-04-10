% Parameters
int: total_acres = 300;                 % Total available land (acres)

int: oil_small_per_acre = 2;            % Barrels of oil per acre for small well
int: oil_large_per_acre = 5;            % Barrels of oil per acre for large well

int: pollution_small_per_acre = 10;     % Pollution units per acre for small well
int: pollution_large_per_acre = 20;     % Pollution units per acre for large well
int: max_pollution = 4500;              % Maximum allowed total pollution

int: bits_small_per_acre = 5;           % Drill bits required per acre for small well
int: bits_large_per_acre = 10;          % Drill bits required per acre for large well
int: available_bits = 2500;             % Total available drill bits

% Variables
var 0..total_acres: acres_small;        % Acres allocated to small wells
var 0..total_acres: acres_large;        % Acres allocated to large wells

var 0..(oil_large_per_acre * total_acres): total_oil; % Total oil production (barrels)

% Constraints
% Land allocation: total acres used by small and large wells cannot exceed available land
constraint acres_small + acres_large <= total_acres;

% Drill bits capacity: total drill bits used cannot exceed available drill bits
constraint
  bits_small_per_acre * acres_small + bits_large_per_acre * acres_large
  <= available_bits;

% Pollution limit: total pollution produced cannot exceed the maximum allowed
constraint
  pollution_small_per_acre * acres_small + pollution_large_per_acre * acres_large
  <= max_pollution;

% Total oil production definition
constraint
  total_oil = oil_small_per_acre * acres_small + oil_large_per_acre * acres_large;

% Objective
solve maximize total_oil;