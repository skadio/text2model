% Parameters
% Fatigue score per hour for each group
int: fatigue_X = 10;
int: fatigue_Y = 15;
int: fatigue_Z = 5;

% Constraint constants
int: min_X_plus_Y = 8;      % X + Y >= 8
int: max_Y_plus_Z = 20;     % Y + Z <= 20
int: min_X_minus_Z = 3;     % X >= Z + 3

% Explicit bounds on weekly training hours (non-negative; whole hours)
int: min_hours = 0;

% Variables
% Weekly training hours for each group (whole numbers)
var min_hours..max_Y_plus_Z: hours_X;  % safe upper bound from Y+Z <= 20
var min_hours..max_Y_plus_Z: hours_Y;
var min_hours..max_Y_plus_Z: hours_Z;

% Total fatigue score (objective value)
var 0..(max_Y_plus_Z * (fatigue_X + fatigue_Y + fatigue_Z)): total_fatigue;

% Constraints
% Link total fatigue to training hours (linear definition)
constraint
  total_fatigue =
    fatigue_X * hours_X +
    fatigue_Y * hours_Y +
    fatigue_Z * hours_Z;

% Balanced training: strength + skill must be at least the minimum required hours
constraint
  hours_X + hours_Y >= min_X_plus_Y;

% Over-training prevention: skill + strategy must not exceed the maximum allowed hours
constraint
  hours_Y + hours_Z <= max_Y_plus_Z;

% Strength emphasis: strength hours must be at least 3 more than strategy hours
constraint
  hours_X - hours_Z >= min_X_minus_Z;

% Objective
solve minimize total_fatigue;