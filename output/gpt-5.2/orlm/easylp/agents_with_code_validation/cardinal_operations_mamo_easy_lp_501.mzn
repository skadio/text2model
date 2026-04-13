% Parameters
int: cost_residential = 1000;          % Cost per unit for residential investment
int: cost_commercial  = 500;           % Cost per unit for commercial investment

int: max_total_units  = 50;            % Total units of residential + commercial cannot exceed this
int: min_residential  = 10;            % Minimum required residential units
int: min_commercial   = 20;            % Minimum required commercial units
int: max_res_over_com = 10;            % Constraint: x - y <= this

% Variables
var min_residential..max_total_units: x;  % Units of residential investment (integer)
var min_commercial..max_total_units: y;   % Units of commercial investment (integer)

% Constraints
% Total units limit
constraint x + y <= max_total_units;

% Residential units cannot exceed commercial units by more than the limit
constraint x - y <= max_res_over_com;

% Objective
solve minimize cost_residential * x + cost_commercial * y;