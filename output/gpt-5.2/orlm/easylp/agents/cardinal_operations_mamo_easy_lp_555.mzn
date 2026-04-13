% Parameters
int: max_total_hours = 1000;          % Maximum total training hours available
int: min_x_hours = 200;               % Minimum hours for strength conditioning (X)
int: min_y_hours = 150;               % Minimum hours for skill development (Y)
int: min_z_hours = 250;               % Minimum hours for strategy & tactics (Z)

int: fatigue_x = 2;                   % Fatigue per hour for X
int: fatigue_y = 3;                   % Fatigue per hour for Y
int: fatigue_z = 4;                   % Fatigue per hour for Z

% Variables
var min_x_hours..max_total_hours: x_hours;  % Weekly hours allocated to group X
var min_y_hours..max_total_hours: y_hours;  % Weekly hours allocated to group Y
var min_z_hours..max_total_hours: z_hours;  % Weekly hours allocated to group Z

% Upper bound: all 1000 hours in each group (loose but valid)
var 0..(fatigue_x*max_total_hours + fatigue_y*max_total_hours + fatigue_z*max_total_hours): total_fatigue;
                                            % Total fatigue score (objective)

% Constraints
% Total hours capacity constraint (sum of all group hours must not exceed the maximum)
constraint
  x_hours + y_hours + z_hours <= max_total_hours;

% Total fatigue definition constraint (compute fatigue from allocated hours)
constraint
  total_fatigue = fatigue_x * x_hours + fatigue_y * y_hours + fatigue_z * z_hours;

% Objective
solve minimize total_fatigue;