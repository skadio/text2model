% Parameters
int: max_total_hours = 1000;          % Maximum total weekly training hours (X+Y+Z)
int: min_hours_X = 200;              % Minimum hours for strength conditioning (X)
int: min_hours_Y = 150;              % Minimum hours for skill development (Y)
int: min_hours_Z = 250;              % Minimum hours for strategy & tactics (Z)

int: fatigue_per_hour_X = 2;         % Fatigue score per hour for X
int: fatigue_per_hour_Y = 3;         % Fatigue score per hour for Y
int: fatigue_per_hour_Z = 4;         % Fatigue score per hour for Z

% Variables
var min_hours_X..max_total_hours: X;  % Weekly whole hours allocated to group X
var min_hours_Y..max_total_hours: Y;  % Weekly whole hours allocated to group Y
var min_hours_Z..max_total_hours: Z;  % Weekly whole hours allocated to group Z

% Upper bound is the worst case if each group took max_total_hours (safe but loose)
var 0..(fatigue_per_hour_X*max_total_hours
      + fatigue_per_hour_Y*max_total_hours
      + fatigue_per_hour_Z*max_total_hours): total_fatigue; % Total fatigue score

% Constraints
% Total weekly training hours must not exceed the maximum allowed
constraint
  X + Y + Z <= max_total_hours;

% Compute total fatigue score from allocated hours and per-hour fatigue coefficients
constraint
  total_fatigue =
    fatigue_per_hour_X * X +
    fatigue_per_hour_Y * Y +
    fatigue_per_hour_Z * Z;

% Objective
solve minimize total_fatigue;