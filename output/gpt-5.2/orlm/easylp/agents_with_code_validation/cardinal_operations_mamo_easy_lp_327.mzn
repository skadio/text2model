% Parameters
int: max_total_properties = 1000;          % Regulatory maximum total number of properties
int: min_single_family = 400;             % Minimum required single-family homes (X)
int: min_multi_family = 250;              % Minimum required multi-family homes (Y)
int: min_commercial = 350;                % Minimum required commercial buildings (Z)

int: cost_single_family = 200000;         % Cost per single-family home in dollars
int: cost_multi_family = 300000;          % Cost per multi-family home in dollars
int: cost_commercial = 150000;            % Cost per commercial building in dollars

% Variables
var min_single_family..max_total_properties: X;  % Number of single-family homes
var min_multi_family..max_total_properties: Y;   % Number of multi-family homes
var min_commercial..max_total_properties: Z;     % Number of commercial buildings

var 0..(cost_single_family*max_total_properties
      + cost_multi_family*max_total_properties
      + cost_commercial*max_total_properties): total_cost;  % Total cost upper-bounded safely

% Constraints
% Minimum required numbers of each property type
constraint X >= min_single_family;
constraint Y >= min_multi_family;
constraint Z >= min_commercial;

% Regulatory limit on total number of properties
constraint X + Y + Z <= max_total_properties;

% Define total construction cost from unit costs and quantities
constraint
  total_cost = cost_single_family * X
             + cost_multi_family * Y
             + cost_commercial * Z;

% Objective
solve minimize total_cost;