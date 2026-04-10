% Parameters
int: total_hours_limit = 40;          % Budget constraint: total hours across teams
int: min_diff_XY = 5;                 % Team X must work at least this many hours more than Y
int: min_diff_YZ = 10;                % Team Y must work at least this many hours more than Z

int: max_hours_X = 15;                % Weekly maximum hours for team X
int: max_hours_Y = 20;                % Weekly maximum hours for team Y
int: max_hours_Z = 30;                % Weekly maximum hours for team Z

int: fatigue_per_hour_X = 2;          % Fatigue score per hour for team X
int: fatigue_per_hour_Y = 3;          % Fatigue score per hour for team Y
int: fatigue_per_hour_Z = 1;          % Fatigue score per hour for team Z


% Variables
var 0..max_hours_X: hours_X;          % Scheduled integer hours for team X
var 0..max_hours_Y: hours_Y;          % Scheduled integer hours for team Y
var 0..max_hours_Z: hours_Z;          % Scheduled integer hours for team Z

var 0..(fatigue_per_hour_X*max_hours_X
      + fatigue_per_hour_Y*max_hours_Y
      + fatigue_per_hour_Z*max_hours_Z): total_fatigue;   % Total fatigue score (objective)


% Constraints
% Total hours budget constraint across all teams
constraint
  hours_X + hours_Y + hours_Z <= total_hours_limit;

% Minimum hour difference constraints to ensure required coverage/workload distribution
constraint
  hours_X - hours_Y >= min_diff_XY;

constraint
  hours_Y - hours_Z >= min_diff_YZ;

% Define total fatigue as the weighted sum of hours by team-specific fatigue rates
constraint
  total_fatigue =
    fatigue_per_hour_X * hours_X +
    fatigue_per_hour_Y * hours_Y +
    fatigue_per_hour_Z * hours_Z;


% Objective
solve minimize total_fatigue;