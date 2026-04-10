% Parameters
int: max_properties = 100;
int: profit_condo = 5000;
int: profit_apartment = 3000;

int: area_condo_coeff = 60;
int: area_apartment_coeff = 30;
int: min_area = 3000;

% Variables
var 0..max_properties: X; % number of luxury condos
var 0..max_properties: Y; % number of affordable apartments
var 0..(profit_condo*max_properties + profit_apartment*max_properties): total_profit;

% Constraints
constraint X + Y <= max_properties;

constraint area_condo_coeff * X + area_apartment_coeff * Y >= min_area;

constraint total_profit = profit_condo * X + profit_apartment * Y;

% Objective
solve maximize total_profit;