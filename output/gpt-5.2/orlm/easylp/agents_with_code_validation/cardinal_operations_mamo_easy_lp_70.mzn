% Parameters
int: water_per_x = 5;            % Water required per unit of crop X
int: water_per_y = 3;            % Water required per unit of crop Y
int: water_available = 100;      % Total water available

int: yield_coeff_x = 2;          % Coefficient for X in the minimum yield constraint (2*X)
int: yield_coeff_y = 1;          % Coefficient for Y in the minimum yield constraint (1*Y)
int: min_yield = 30;             % Minimum required combined yield

int: cost_per_x = 4;             % Cost per unit of crop X
int: cost_per_y = 2;             % Cost per unit of crop Y


% Variables
var 0..(water_available div water_per_x): x_units;  % Whole units of crop X planted
var 0..(water_available div water_per_y): y_units;  % Whole units of crop Y planted

% Total cost (integer) to minimize
var 0..(cost_per_x*(water_available div water_per_x) + cost_per_y*(water_available div water_per_y)):
    total_cost;


% Constraints
% Water usage must not exceed available water
constraint
    water_per_x * x_units + water_per_y * y_units <= water_available;

% Minimum combined yield requirement
constraint
    yield_coeff_x * x_units + yield_coeff_y * y_units >= min_yield;

% Define total cost from planted units
constraint
    total_cost = cost_per_x * x_units + cost_per_y * y_units;


% Objective
solve minimize total_cost;