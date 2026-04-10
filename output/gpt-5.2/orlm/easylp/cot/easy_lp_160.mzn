% Parameters (with values embedded)
int: max_properties = 100;
int: profit_per_condo = 5000;
int: profit_per_apartment = 3000;

% Living-area style constraint data (as given)
int: condos_area_bundle = 60;
int: apartments_area_bundle = 30;
int: min_total_area = 3000;

% Variables
var 0..max_properties: X; % number of luxury condos
var 0..max_properties: Y; % number of affordable apartments

% Constraints
constraint X + Y <= max_properties;
constraint condos_area_bundle * X + apartments_area_bundle * Y >= min_total_area;

% Objective
var int: total_profit = profit_per_condo * X + profit_per_apartment * Y;
solve maximize total_profit;

output [
  "X (condos) = ", show(X), "\n",
  "Y (apartments) = ", show(Y), "\n",
  "Maximum profit ($) = ", show(total_profit), "\n"
];