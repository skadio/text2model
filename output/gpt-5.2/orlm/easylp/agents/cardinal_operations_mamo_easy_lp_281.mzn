% Parameters
int: max_total_tourists = 50;          % Maximum total tourists allowed across all trips (pandemic restriction)

int: min_x_tourists = 10;             % Minimum tourists required for trip X
int: min_y_tourists = 5;              % Minimum tourists required for trip Y
int: min_z_tourists = 8;              % Minimum tourists required for trip Z

int: cost_x = 100;                    % Cost per tourist for trip X (dollars)
int: cost_y = 80;                     % Cost per tourist for trip Y (dollars)
int: cost_z = 150;                    % Cost per tourist for trip Z (dollars)

% Variables
var min_x_tourists..max_total_tourists: x;   % Number of tourists assigned to trip X
var min_y_tourists..max_total_tourists: y;   % Number of tourists assigned to trip Y
var min_z_tourists..max_total_tourists: z;   % Number of tourists assigned to trip Z

var 0..(cost_x*max_total_tourists + cost_y*max_total_tourists + cost_z*max_total_tourists): total_cost;
                                             % Total cost in dollars (integer)

% Constraints
% Total tourists across all trips must not exceed the pandemic restriction
constraint x + y + z <= max_total_tourists;

% Define total cost as the sum of per-tourist costs across trips
constraint total_cost = cost_x * x + cost_y * y + cost_z * z;

% Objective
solve minimize total_cost;