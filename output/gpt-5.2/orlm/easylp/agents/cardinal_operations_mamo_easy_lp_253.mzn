% Parameters
int: max_xy = 100;             % Maximum allowed units for X + Y
int: max_xz = 80;              % Maximum allowed units for X + Z
int: min_yz = 70;              % Minimum required units for Y + Z

int: cost_x = 2;               % Cost per unit of resource X
int: cost_y = 3;               % Cost per unit of resource Y
int: cost_z = 1;               % Cost per unit of resource Z


% Variables
var 0..max(max_xy, max_xz): x; % Allocated units of X (non-negative integer)
var 0..max_xy: y;              % Allocated units of Y (non-negative integer)
var 0..max_xz: z;              % Allocated units of Z (non-negative integer)

var int: total_cost;           % Total cost (integer)


% Constraints
% Availability constraint: combined allocation of X and Y is limited
constraint x + y <= max_xy;

% Logistical constraint: combined allocation of X and Z is limited
constraint x + z <= max_xz;

% Production efficiency constraint: combined allocation of Y and Z must meet a minimum
constraint y + z >= min_yz;

% Total cost calculation (linear cost expression)
constraint total_cost = cost_x * x + cost_y * y + cost_z * z;


% Objective
solve minimize total_cost;