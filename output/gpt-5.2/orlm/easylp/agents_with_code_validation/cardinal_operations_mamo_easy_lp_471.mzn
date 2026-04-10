% Parameters
int: fatigue_X = 10;          % Fatigue score per hour for group X (strength)
int: fatigue_Y = 20;          % Fatigue score per hour for group Y (skill)

int: max_facility = 60;       % Upper bound for 3*X + 2*Y
int: min_total_hours = 12;    % Lower bound for X + Y
int: max_diff = 8;            % Upper bound for |Y - X|

% Variables
var 0..max_facility: hours_X; % Weekly training hours for group X (non-negative integer)
var 0..max_facility: hours_Y; % Weekly training hours for group Y (non-negative integer)

var int: total_fatigue;       % Total fatigue score to minimize

% Constraints
% Facility/trainer capacity: 3*X + 2*Y must not exceed available capacity
constraint 3 * hours_X + 2 * hours_Y <= max_facility;

% Minimum total training to ensure balanced weekly program
constraint hours_X + hours_Y >= min_total_hours;

% Balance constraint: keep skill vs strength hours within the allowed difference
constraint abs(hours_Y - hours_X) <= max_diff;

% Define total fatigue from per-hour fatigue scores
constraint total_fatigue = fatigue_X * hours_X + fatigue_Y * hours_Y;

% Objective
solve minimize total_fatigue;