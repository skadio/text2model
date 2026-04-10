% Parameters
% Fatigue score per hour for each training group
int: fatigue_x1 = 5; % strength conditioning
int: fatigue_x2 = 4; % skill development
int: fatigue_x3 = 3; % strategy and tactics
int: fatigue_x4 = 6; % recovery

% Constraint constants (hours)
int: max_x1_x2 = 15;        % X1 + X2 <= 15
int: min_x2_x3 = 10;        % X2 + X3 >= 10
int: max_diff_x3_x4 = 8;    % |X3 - X4| <= 8

% Strategic objective: X1 >= 2*X4 + 5
int: extra_strength = 5;

% Safe explicit upper bound for weekly hours (needed for bounded vars)
int: max_hours = 33;

% Variables
var 0..max_hours: x1; % weekly hours for strength conditioning
var 0..max_hours: x2; % weekly hours for skill development
var 0..max_hours: x3; % weekly hours for strategy and tactics
var 0..max_hours: x4; % weekly hours for recovery

% Total fatigue score variable
var 0..(max_hours * (fatigue_x1 + fatigue_x2 + fatigue_x3 + fatigue_x4)): total_fatigue;

% Constraints
% Link total fatigue score to training hour decisions
constraint total_fatigue =
  fatigue_x1 * x1 + fatigue_x2 * x2 + fatigue_x3 * x3 + fatigue_x4 * x4;

% Weekly cap on combined strength conditioning and skill development
constraint x1 + x2 <= max_x1_x2;

% Minimum combined hours for balanced training (skill + strategy)
constraint x2 + x3 >= min_x2_x3;

% Prevent overtraining: strategy and recovery hours must not differ too much
constraint abs(x3 - x4) <= max_diff_x3_x4;

% Strategic objective emphasizing physicality: strength at least 5 more than twice recovery
constraint x1 >= 2 * x4 + extra_strength;

% Objective
solve minimize total_fatigue;