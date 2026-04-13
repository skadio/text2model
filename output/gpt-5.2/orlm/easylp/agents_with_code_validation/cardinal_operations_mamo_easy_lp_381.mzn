% Parameters
% Fatigue score per hour for each training group
int: fatigue_x1 = 5;   % strength conditioning
int: fatigue_x2 = 4;   % skill development
int: fatigue_x3 = 3;   % strategy and tactics
int: fatigue_x4 = 6;   % recovery

% Weekly time limits / thresholds (given by the problem statement)
int: max_x1_plus_x2 = 15;     % X1 + X2 <= 15
int: min_x2_plus_x3 = 10;     % X2 + X3 >= 10
int: max_diff_x3_x4 = 8;      % |X3 - X4| <= 8

% "At least five more hours dedicated to X1 compared to twice X4"
int: min_x1_minus_2x4 = 5;    % X1 - 2*X4 >= 5

% Safe upper bound for each weekly-hours decision variable
int: max_hours = 15;

% Variables
var 0..max_hours: x1; % weekly hours for strength conditioning (X1)
var 0..max_hours: x2; % weekly hours for skill development (X2)
var 0..max_hours: x3; % weekly hours for strategy and tactics (X3)
var 0..max_hours: x4; % weekly hours for recovery (X4)

var int: total_fatigue; % total fatigue score (objective expression)

% Constraints
% Total fatigue definition (linear combination of hours and per-hour fatigue scores)
constraint
  total_fatigue =
    fatigue_x1 * x1 +
    fatigue_x2 * x2 +
    fatigue_x3 * x3 +
    fatigue_x4 * x4;

% Weekly schedule cap: strength + skill cannot exceed the given maximum
constraint x1 + x2 <= max_x1_plus_x2;

% Balanced training requirement: skill + strategy must meet the minimum threshold
constraint x2 + x3 >= min_x2_plus_x3;

% Overtraining prevention: difference between strategy and recovery bounded
constraint abs(x3 - x4) <= max_diff_x3_x4;

% Strategic objective: strength must be at least 5 more than twice recovery
constraint x1 - 2 * x4 >= min_x1_minus_2x4;

% Objective
solve minimize total_fatigue;