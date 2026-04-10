% Parameters
int: max_properties = 100;
int: profit_condo = 5000;
int: profit_apartment = 3000;

int: area_coeff_condo = 60;
int: area_coeff_apartment = 30;
int: min_total_area = 3000;

% Variables
var 0..max_properties: X; % luxury condos
var 0..max_properties: Y; % affordable apartments
var 0..(profit_condo*max_properties + profit_apartment*max_properties): total_profit;

% Constraints
constraint X + Y <= max_properties;

constraint area_coeff_condo * X + area_coeff_apartment * Y >= min_total_area;

constraint total_profit = profit_condo * X + profit_apartment * Y;

% Objective
solve maximize total_profit;