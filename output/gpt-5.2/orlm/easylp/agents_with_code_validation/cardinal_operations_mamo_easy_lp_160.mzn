% Parameters
int: max_properties = 100;                 % Maximum total number of properties (zoning restriction)

int: profit_condo = 5000;                  % Profit per luxury condo ($)
int: profit_apartment = 3000;              % Profit per affordable apartment ($)

int: area_coeff_condo = 60;                % Living-area contribution coefficient for condos
int: area_coeff_apartment = 30;            % Living-area contribution coefficient for apartments
int: min_total_area = 3000;                % Minimum required combined living area (sq ft)

% Variables
var 0..max_properties: X;                  % Number of luxury condos
var 0..max_properties: Y;                  % Number of affordable apartments

% Upper bound uses the best profit per unit times max properties (safe bound).
var 0..(max_properties * max(profit_condo, profit_apartment)): total_profit;

% Constraints
% Zoning restriction: total number of properties cannot exceed the maximum
constraint X + Y <= max_properties;

% Community development agreement: minimum combined living area requirement
constraint area_coeff_condo * X + area_coeff_apartment * Y >= min_total_area;

% Define total profit
constraint total_profit = profit_condo * X + profit_apartment * Y;

% Objective
solve maximize total_profit;