% Parameters
% Fatigue per session for each group
int: fatigue_X = 4;
int: fatigue_Y = 2;
int: fatigue_Z = 3;

% Constraint constants
int: min_X_plus_Y = 6;      % X + Y >= 6
int: max_abs_Y_minus_Z = 1; % |Y - Z| <= 1
int: max_X_plus_Z = 8;      % X + Z <= 8

% Session bounds (non-negative sessions implied)
int: min_sessions = 0;

% Variables
var int: X; % number of strength training sessions
var int: Y; % number of agility drill sessions
var int: Z; % number of strategic planning sessions

% Total fatigue to minimize
var int: total_fatigue;

% Constraints
% --- Session non-negativity (whole-number sessions, lower-bounded) ---
constraint X >= min_sessions;
constraint Y >= min_sessions;
constraint Z >= min_sessions;

% --- Weekly scheduling requirements ---
% Minimum combined sessions for groups X and Y
constraint X + Y >= min_X_plus_Y;

% Balance between agility (Y) and strategy (Z): difference at most 1
constraint abs(Y - Z) <= max_abs_Y_minus_Z;

% Maximum combined sessions for groups X and Z
constraint X + Z <= max_X_plus_Z;

% --- Total fatigue accounting ---
constraint total_fatigue = fatigue_X * X + fatigue_Y * Y + fatigue_Z * Z;

% Objective
solve minimize total_fatigue;