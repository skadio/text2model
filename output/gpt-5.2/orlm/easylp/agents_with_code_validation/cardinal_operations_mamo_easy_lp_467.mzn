% Parameters
int: max_total_hires = 10;          % Total hires cannot exceed this number
int: min_hires_x = 3;              % Minimum hires required for position X
int: min_hires_y = 2;              % Minimum hires required for position Y
int: max_hires_x = 7;              % Maximum hires allowed for position X
int: max_hires_y = 8;              % Maximum hires allowed for position Y
int: cost_x = 50000;               % Cost per hire for position X (dollars)
int: cost_y = 40000;               % Cost per hire for position Y (dollars)

% Variables
var min_hires_x..max_hires_x: hires_x;  % Number of hires for position X (integer)
var min_hires_y..max_hires_y: hires_y;  % Number of hires for position Y (integer)
var 0..(cost_x * max_hires_x + cost_y * max_hires_y): total_cost; % Total hiring cost (dollars)

% Constraints
% Total hires limit (overall cap)
constraint hires_x + hires_y <= max_total_hires;

% Total cost definition
constraint total_cost = cost_x * hires_x + cost_y * hires_y;

% Objective
solve minimize total_cost;