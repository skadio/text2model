% Parameters
int: max_total_hours = 24;              % Total hours limit across all employees
int: min_x_over_y = 2;                  % X must work at least this many hours more than Y
int: max_yz_hours = 16;                 % Combined hours limit for Y and Z

int: x_min = 0; int: x_max = 10;        % Bounds on X's hours
int: y_min = 0; int: y_max = 8;         % Bounds on Y's hours
int: z_min = 0; int: z_max = 6;         % Bounds on Z's hours

int: cost_x = 8;                        % Cost per hour for X
int: cost_y = 6;                        % Cost per hour for Y
int: cost_z = 5;                        % Cost per hour for Z

% Variables
var x_min..x_max: hours_x;              % Integer working hours for employee X
var y_min..y_max: hours_y;              % Integer working hours for employee Y
var z_min..z_max: hours_z;              % Integer working hours for employee Z

var 0..(cost_x*x_max + cost_y*y_max + cost_z*z_max): total_cost;  % Total cost (bounded)

% Constraints
% Total hours limit across all employees (labor law constraint)
constraint
  hours_x + hours_y + hours_z <= max_total_hours;

% Role requirement: X must work at least min_x_over_y more hours than Y
constraint
  hours_x >= hours_y + min_x_over_y;

% Workspace availability: combined hours for Y and Z cannot exceed max_yz_hours
constraint
  hours_y + hours_z <= max_yz_hours;

% Define total cost from individual hours and per-hour costs
constraint
  total_cost = cost_x * hours_x + cost_y * hours_y + cost_z * hours_z;

% Objective
solve minimize total_cost;