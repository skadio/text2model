% Parameters
int: max_total_hours = 10;            % Total hours limit for X+Y
int: min_diff_xy = 1;                % X must be at least Y + 1
int: eq_2x_plus_y = 15;              % Exact requirement: 2*X + Y = 15

int: fatigue_per_hour_x = 2;         % Fatigue points per hour of strength conditioning (X)
int: fatigue_per_hour_y = 3;         % Fatigue points per hour of skill development (Y)

% Variables
var 0..max_total_hours: x_hours;     % Integer hours allocated to strength conditioning (X)
var 0..max_total_hours: y_hours;     % Integer hours allocated to skill development (Y)
var 0..(fatigue_per_hour_x*max_total_hours + fatigue_per_hour_y*max_total_hours): total_fatigue;
                                     % Total fatigue score to minimize

% Constraints
% Total hours limit: combined training time cannot exceed the maximum allowed
constraint
  x_hours + y_hours <= max_total_hours;

% Balance requirement: strength conditioning must be at least one hour more than skill development
constraint
  x_hours >= y_hours + min_diff_xy;

% Exact composition requirement: 2*X + Y must equal the specified total
constraint
  2 * x_hours + y_hours = eq_2x_plus_y;

% Define total fatigue from chosen hours (keeps objective expression separate and consistent)
constraint
  total_fatigue = fatigue_per_hour_x * x_hours + fatigue_per_hour_y * y_hours;

% Objective
solve minimize total_fatigue;