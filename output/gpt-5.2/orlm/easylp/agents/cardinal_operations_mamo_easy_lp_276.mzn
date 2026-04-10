% Parameters
int: max_total_hours = 30;            % Total available hours for all exercises
int: min_diff_XY = 5;                % X must be at least this many hours more than Y
int: max_abs_diff_ZX = 10;           % |Z - X| cannot exceed this value

int: fatigue_X = 10;                 % Fatigue per hour for exercise X (cardio)
int: fatigue_Y = 15;                 % Fatigue per hour for exercise Y (strength)
int: fatigue_Z = 20;                 % Fatigue per hour for exercise Z (flexibility)

% Variables
var 0..max_total_hours: hours_X;     % Integer hours for exercise X
var 0..max_total_hours: hours_Y;     % Integer hours for exercise Y
var 0..max_total_hours: hours_Z;     % Integer hours for exercise Z

% Upper bound assumes all 30 hours could be spent on each type (loose but safe)
var 0..(fatigue_X*max_total_hours + fatigue_Y*max_total_hours + fatigue_Z*max_total_hours): total_fatigue;

% Constraints
% Total hours limit: sum of exercise hours cannot exceed available weekly hours
constraint
  hours_X + hours_Y + hours_Z <= max_total_hours;

% Balance constraint between X and Y: X must be at least min_diff_XY more than Y
constraint
  hours_X - hours_Y >= min_diff_XY;

% Proximity constraint between Z and X: absolute difference cannot exceed max_abs_diff_ZX
constraint
  abs(hours_Z - hours_X) <= max_abs_diff_ZX;

% Define total fatigue as the weighted sum of hours by fatigue per hour
constraint
  total_fatigue = fatigue_X * hours_X + fatigue_Y * hours_Y + fatigue_Z * hours_Z;

% Objective
solve minimize total_fatigue;