% Parameters
int: max_units = 1000;              % Upper bound on total invested units (X + Y)
int: min_diversity = 500;           % Minimum required value for (2*X + Y)
int: max_difference = 200;          % Maximum allowed absolute difference |X - Y|
int: cost_x = 200;                  % Cost per unit of property X
int: cost_y = 300;                  % Cost per unit of property Y

% Variables
var 0..max_units: x_units;          % Units invested in property X (nonnegative integer)
var 0..max_units: y_units;          % Units invested in property Y (nonnegative integer)
var 0..(cost_x*max_units + cost_y*max_units): total_cost;  % Total investment cost in dollars

% Constraints
% Total units limit: cannot invest in more than max_units combined
constraint x_units + y_units <= max_units;

% Diversity requirement: ensure 2*X + Y meets or exceeds the minimum threshold
constraint 2 * x_units + y_units >= min_diversity;

% Exposure control: absolute difference between X and Y cannot exceed max_difference
constraint abs(x_units - y_units) <= max_difference;

% Total cost definition: link total_cost to the chosen number of units
constraint total_cost = cost_x * x_units + cost_y * y_units;

% Objective
solve minimize total_cost;