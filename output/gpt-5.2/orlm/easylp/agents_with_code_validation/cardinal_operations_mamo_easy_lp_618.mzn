% Parameters
% Fatigue score per hour for each team
int: fatigue_x1 = 2;
int: fatigue_x2 = 3;
int: fatigue_x3 = 4;
int: fatigue_x4 = 5;

% Constraint constants
int: max_x1_x2 = 8;      % x1 + x2 <= 8
int: min_2x2_x3 = 10;    % 2*x2 + x3 >= 10
int: max_x3_3x4 = 15;    % x3 - 3*x4 <= 15
int: diff_x4_x1 = 5;     % x4 - x1 = 5


% Variables
% Whole-number hours allocated to each team (non-negative)
var 0..100: hours_x1;    % Team X1 hours
var 0..100: hours_x2;    % Team X2 hours
var 0..100: hours_x3;    % Team X3 hours
var 0..100: hours_x4;    % Team X4 hours

% Total fatigue score (bounded for linear objective)
var 0..10000: total_fatigue;


% Constraints
% --- Team availability / capacity constraints ---
constraint hours_x1 + hours_x2 <= max_x1_x2;

% --- Project demand constraints ---
constraint 2 * hours_x2 + hours_x3 >= min_2x2_x3;

% --- Workload balance constraints ---
constraint hours_x3 - 3 * hours_x4 <= max_x3_3x4;

% --- Coordination constraint between teams ---
constraint hours_x4 - hours_x1 = diff_x4_x1;

% --- Total fatigue accounting constraint ---
constraint total_fatigue =
    fatigue_x1 * hours_x1 +
    fatigue_x2 * hours_x2 +
    fatigue_x3 * hours_x3 +
    fatigue_x4 * hours_x4;


% Objective
solve minimize total_fatigue;