% Parameters
int: max_total_hours = 10;                 % Maximum combined training hours (X + Y <= 10)
int: min_diff_xy = 1;                      % Minimum difference: X >= Y + 1
int: eq_2x_plus_y = 15;                    % Exact requirement: 2*X + Y = 15

int: fatigue_per_hour_x = 2;               % Fatigue points per hour of strength conditioning (X)
int: fatigue_per_hour_y = 3;               % Fatigue points per hour of skill development (Y)

% Variables
var 0..max_total_hours: X;                 % Integer hours of strength conditioning
var 0..max_total_hours: Y;                 % Integer hours of skill development
var 0..(fatigue_per_hour_x*max_total_hours + fatigue_per_hour_y*max_total_hours): total_fatigue;
                                          % Total fatigue score (bounded by worst-case within max hours)

% Constraints
% Total training hours cannot exceed maximum allowed
constraint X + Y <= max_total_hours;

% Strength conditioning must be at least `min_diff_xy` hours more than skill development
constraint X >= Y + min_diff_xy;

% Exact balance requirement on training hours: 2*X + Y must equal specified value
constraint 2 * X + Y == eq_2x_plus_y;

% Define total fatigue as linear combination of hours and per-hour fatigue rates
constraint total_fatigue == fatigue_per_hour_x * X + fatigue_per_hour_y * Y;

% Objective
solve minimize total_fatigue;

% Output
output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "total_fatigue=", show(total_fatigue), "\n"
];