% Parameters
int: fatigue_X = 10;              % Fatigue score per hour for group X (strength)
int: fatigue_Y = 15;              % Fatigue score per hour for group Y (skills)
int: fatigue_Z = 5;               % Fatigue score per hour for group Z (strategy)

int: min_X_plus_Y = 8;            % Constraint: X + Y >= 8
int: max_Y_plus_Z = 20;           % Constraint: Y + Z <= 20
int: min_X_minus_Z = 3;           % Constraint: X >= Z + 3

int: min_hours = 0;               % Non-negative training hours lower bound
int: max_hours = 1000;            % Practical large upper bound

% Variables
var min_hours..max_hours: hours_X;  % Weekly hours for group X (integer hours)
var min_hours..max_hours: hours_Y;  % Weekly hours for group Y (integer hours)
var min_hours..max_hours: hours_Z;  % Weekly hours for group Z (integer hours)

% Total fatigue (bounded using max_hours and per-hour fatigue rates)
var 0..(fatigue_X*max_hours + fatigue_Y*max_hours + fatigue_Z*max_hours): total_fatigue;

% Constraints
% Link total fatigue to hours allocated to each group
constraint
  total_fatigue = fatigue_X * hours_X + fatigue_Y * hours_Y + fatigue_Z * hours_Z;

% Balanced training requirement: strength + skills must be at least the minimum
constraint
  hours_X + hours_Y >= min_X_plus_Y;

% Over-training prevention: skills + strategy must not exceed the maximum
constraint
  hours_Y + hours_Z <= max_Y_plus_Z;

% Priority on strength conditioning: strength must exceed strategy by at least a margin
constraint
  hours_X >= hours_Z + min_X_minus_Z;

% Objective
solve minimize total_fatigue;