% Parameters
int: total_acres = 300;                 % Total available land (acres)

int: oil_per_acre_small = 2;            % Barrels per acre for small well
int: oil_per_acre_large = 5;            % Barrels per acre for large well

int: pollution_per_acre_small = 10;     % Pollution units per acre for small well
int: pollution_per_acre_large = 20;     % Pollution units per acre for large well
int: max_pollution = 4500;              % Maximum allowed pollution units

int: bits_per_acre_small = 5;           % Drill bits per acre for small well
int: bits_per_acre_large = 10;          % Drill bits per acre for large well
int: available_bits = 2500;             % Total available drill bits

% Variables
var 0..total_acres: acres_small;        % Acres assigned to small wells
var 0..total_acres: acres_large;        % Acres assigned to large wells

var 0..(oil_per_acre_small*total_acres + oil_per_acre_large*total_acres): total_oil;
                                        % Total oil production (barrels)

% Constraints
% Land use constraint: total acres allocated cannot exceed available land
constraint
  acres_small + acres_large <= total_acres;

% Drill bits availability constraint: total bits used cannot exceed available bits
constraint
  bits_per_acre_small * acres_small + bits_per_acre_large * acres_large
  <= available_bits;

% Pollution limit constraint: total pollution generated cannot exceed legal maximum
constraint
  pollution_per_acre_small * acres_small + pollution_per_acre_large * acres_large
  <= max_pollution;

% Total oil production definition constraint
constraint
  total_oil = oil_per_acre_small * acres_small + oil_per_acre_large * acres_large;

% Objective
solve maximize total_oil;