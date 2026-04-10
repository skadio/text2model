% Parameters
int: max_properties = 100;                  % Zoning restriction: maximum total number of properties
int: profit_per_condo = 5000;               % Profit per luxury condo ($)
int: profit_per_apartment = 3000;           % Profit per affordable apartment ($)

int: area_coeff_condo = 60;                 % Living area coefficient for condos in the agreement constraint
int: area_coeff_apartment = 30;             % Living area coefficient for apartments in the agreement constraint
int: min_required_area = 3000;              % Minimum combined living area required (sq ft)

% Variables
var 0..max_properties: X;                   % Number of luxury condos
var 0..max_properties: Y;                   % Number of affordable apartments
var 0..(max_properties * profit_per_condo): profit; % Total profit ($)

% Constraints
constraint X + Y <= max_properties;  % Total properties constraint (zoning restriction)

constraint
  area_coeff_condo * X + area_coeff_apartment * Y >= min_required_area; % Minimum combined living area

constraint
  profit = profit_per_condo * X + profit_per_apartment * Y; % Total profit definition

% Objective
solve maximize profit;