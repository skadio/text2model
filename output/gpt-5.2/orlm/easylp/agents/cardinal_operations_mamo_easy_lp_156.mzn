% Parameters
int: max_total_properties = 100;     % Total number of properties cannot exceed this
int: villa_min = 30;                % Minimum number of villas
int: villa_max = 70;                % Maximum number of villas
int: apartment_min = 20;            % Minimum number of apartments
int: apartment_max = 80;            % Maximum number of apartments
int: cost_villa = 5000;             % Cost to build one villa (dollars)
int: cost_apartment = 3000;         % Cost to build one apartment (dollars)

% Variables
var villa_min..villa_max: villas;                % Number of luxury villas to build (X)
var apartment_min..apartment_max: apartments;    % Number of apartments to build (Y)
var 0..(cost_villa * villa_max + cost_apartment * apartment_max): total_cost; % Total construction cost

% Constraints
% Total property count must respect the overall cap
constraint villas + apartments <= max_total_properties;

% Define total construction cost
constraint total_cost = cost_villa * villas + cost_apartment * apartments;

% Objective
solve minimize total_cost;