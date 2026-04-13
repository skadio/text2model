% Parameters
% Fatigue score per session for each group
int: fatigue_X = 4;
int: fatigue_Y = 2;
int: fatigue_Z = 3;

% Constraint thresholds
int: min_X_plus_Y = 6;     % X + Y >= 6
int: max_Y_minus_Z = 1;    % |Y - Z| <= 1 (difference should not exceed 1)
int: max_X_plus_Z = 8;     % X + Z <= 8


% Variables
% Number of weekly sessions for each group (whole numbers, non-negative)
var 0..100: sessions_X; % strength training sessions
var 0..100: sessions_Y; % agility drill sessions
var 0..100: sessions_Z; % strategic planning sessions

% Total fatigue (bounded for linear expressions)
var 0..(100 * (fatigue_X + fatigue_Y + fatigue_Z)): total_fatigue;


% Constraints
% --- Training schedule feasibility constraints ---

% Minimum combined sessions for strength (X) and agility (Y)
constraint
  sessions_X + sessions_Y >= min_X_plus_Y;

% Balance constraint: agility (Y) and strategy (Z) session counts differ by at most 1
constraint
  abs(sessions_Y - sessions_Z) <= max_Y_minus_Z;

% Maximum combined sessions for strength (X) and strategy (Z) to avoid overwork
constraint
  sessions_X + sessions_Z <= max_X_plus_Z;

% --- Total fatigue computation constraint ---

% Define total fatigue as the weighted sum of sessions by group fatigue scores
constraint
  total_fatigue =
    fatigue_X * sessions_X +
    fatigue_Y * sessions_Y +
    fatigue_Z * sessions_Z;


% Objective
solve minimize total_fatigue;