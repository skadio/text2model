% Parameters
int: fatigue_X = 10;          % Fatigue per hour for group X (endurance)
int: fatigue_Y = 15;          % Fatigue per hour for group Y (skill development)
int: fatigue_Z = 20;          % Fatigue per hour for group Z (strategy)

int: total_hours_max = 100;   % Weekly total training hours limit

int: diff_XY_min = 20;        % Minimum required difference: X - Y >= 20
int: diff_ZX_max = 30;        % Maximum allowed difference: Z - X <= 30

int: X_max = 60;              % Upper bound on hours for group X
int: Y_max = 50;              % Upper bound on hours for group Y
int: Z_max = 70;              % Upper bound on hours for group Z

% Variables
var 0..X_max: hours_X;        % Training hours for group X (integer)
var 0..Y_max: hours_Y;        % Training hours for group Y (integer)
var 0..Z_max: hours_Z;        % Training hours for group Z (integer)

% Total fatigue score (bounded linear expression)
var 0..(fatigue_X*X_max + fatigue_Y*Y_max + fatigue_Z*Z_max): total_fatigue;

% Constraints
% Link total fatigue to the weighted sum of training hours
constraint
  total_fatigue = fatigue_X * hours_X
                + fatigue_Y * hours_Y
                + fatigue_Z * hours_Z;

% Weekly total training hours must not exceed the allowed maximum
constraint
  hours_X + hours_Y + hours_Z <= total_hours_max;

% Ensure endurance (X) exceeds skill development (Y) by at least the required difference
constraint
  hours_X - hours_Y >= diff_XY_min;

% Ensure strategy (Z) does not exceed endurance (X) by more than the allowed difference
constraint
  hours_Z - hours_X <= diff_ZX_max;

% Objective
solve minimize total_fatigue;