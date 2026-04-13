% Parameters
int: total_hours_max = 40;            % Budget limit on total weekly hours
int: x_min_over_y = 5;                % Team X must work at least this many hours more than Y
int: y_min_over_z = 10;               % Team Y must work at least this many hours more than Z

int: x_hours_max = 15;                % Max weekly hours for Team X
int: y_hours_max = 20;                % Max weekly hours for Team Y
int: z_hours_max = 30;                % Max weekly hours for Team Z

int: fatigue_x = 2;                   % Fatigue per hour for Team X
int: fatigue_y = 3;                   % Fatigue per hour for Team Y
int: fatigue_z = 1;                   % Fatigue per hour for Team Z

% Variables
var 0..x_hours_max: hours_x;          % Weekly hours scheduled for Team X (integer)
var 0..y_hours_max: hours_y;          % Weekly hours scheduled for Team Y (integer)
var 0..z_hours_max: hours_z;          % Weekly hours scheduled for Team Z (integer)

var 0..(fatigue_x*x_hours_max + fatigue_y*y_hours_max + fatigue_z*z_hours_max): total_fatigue;
                                      % Total fatigue score to minimize (integer)

% Constraints

% Budget constraint: total weekly hours across all teams cannot exceed the maximum
constraint
  hours_x + hours_y + hours_z <= total_hours_max;

% Coverage / workload distribution constraints: minimum hour differences between teams
constraint
  hours_x >= hours_y + x_min_over_y;
constraint
  hours_y >= hours_z + y_min_over_z;

% Fatigue accounting: define total_fatigue as the weighted sum of team hours
constraint
  total_fatigue = fatigue_x * hours_x + fatigue_y * hours_y + fatigue_z * hours_z;

% Objective
solve minimize total_fatigue;