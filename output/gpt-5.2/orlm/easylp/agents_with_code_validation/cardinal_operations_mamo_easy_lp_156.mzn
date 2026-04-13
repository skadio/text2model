% Parameters
int: max_total_properties = 100;        % Total properties limit (X + Y <= 100)
int: villas_min = 30;                  % Minimum number of luxury villas (X)
int: villas_max = 70;                  % Maximum number of luxury villas (X)
int: apartments_min = 20;              % Minimum number of apartments (Y)
int: apartments_max = 80;              % Maximum number of apartments (Y)
int: cost_per_villa = 5000;            % Construction cost per villa (dollars)
int: cost_per_apartment = 3000;        % Construction cost per apartment (dollars)

% Variables
var villas_min..villas_max: villas;                % Number of villas to build (integer)
var apartments_min..apartments_max: apartments;    % Number of apartments to build (integer)
var 0..(cost_per_villa*villas_max + cost_per_apartment*apartments_max): total_cost; % Total cost (dollars)

% Constraints
% Total properties limit due to zoning/land restrictions
constraint villas + apartments <= max_total_properties;

% Define total construction cost from decision variables and unit costs
constraint total_cost = cost_per_villa * villas + cost_per_apartment * apartments;

% Objective
solve minimize total_cost;