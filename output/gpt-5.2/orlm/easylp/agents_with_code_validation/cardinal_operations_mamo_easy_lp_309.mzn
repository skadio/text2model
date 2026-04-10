% Parameters
int: max_total_resources = 100;          % Upper limit on total deployed units
int: req_strength_xy = 50;               % Minimum required strength for 2*X + 1*Y
int: req_strength_xz = 40;               % Minimum required strength for 1*X + 1*Z

int: cost_x = 5000;                      % Cost per unit of X
int: cost_y = 4000;                      % Cost per unit of Y
int: cost_z = 6000;                      % Cost per unit of Z

% Variables
var 0..max_total_resources: units_x;     % Number of units deployed to X
var 0..max_total_resources: units_y;     % Number of units deployed to Y
var 0..max_total_resources: units_z;     % Number of units deployed to Z

var int: total_cost;                     % Total cost to minimize

% Constraints
% Resource limit: total deployed units cannot exceed logistical maximum
constraint units_x + units_y + units_z <= max_total_resources;

% Strategic strength requirement for X and Y: 2*X + Y must be at least req_strength_xy
constraint 2 * units_x + units_y >= req_strength_xy;

% Strategic strength requirement for X and Z: X + Z must be at least req_strength_xz
constraint units_x + units_z >= req_strength_xz;

% Total cost calculation based on per-unit operational costs
constraint total_cost = cost_x * units_x + cost_y * units_y + cost_z * units_z;

% Objective
solve minimize total_cost;