% Parameters (with values embedded)
int: max_total_properties = 100;
int: X_min = 30;
int: X_max = 70;
int: Y_min = 20;
int: Y_max = 80;
int: cost_villa = 5000;
int: cost_apartment = 3000;

% Variables
var X_min..X_max: X;  % number of luxury villas
var Y_min..Y_max: Y;  % number of apartments
var 0..(cost_villa * X_max + cost_apartment * Y_max): total_cost;

% Constraints
constraint X + Y <= max_total_properties;
constraint total_cost = cost_villa * X + cost_apartment * Y;

% Objective
solve minimize total_cost;