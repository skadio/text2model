% Parameters
% Maximum total matches allowed
int: max_total_matches = 50;

% Minimum competitiveness requirement: 2*X + Y >= min_competitiveness
int: min_competitiveness = 30;

% Balance requirement: X - 2*Y <= max_balance_diff
int: max_balance_diff = 10;

% Fatigue per match
int: fatigue_x = 4;
int: fatigue_y = 3;

% Upper bounds for decision variables (safe explicit bounds)
int: max_x = max_total_matches;
int: max_y = max_total_matches;

% Variables
% Number of matches in sport X and sport Y (integers by default in MiniZinc)
var 0..max_x: matches_x;
var 0..max_y: matches_y;

% Total fatigue score to minimize
var 0..(fatigue_x * max_x + fatigue_y * max_y): total_fatigue;

% Constraints
% Total matches capacity constraint: X + Y <= 50
constraint matches_x + matches_y <= max_total_matches;

% Competitiveness constraint: 2*X + Y >= 30
constraint 2 * matches_x + matches_y >= min_competitiveness;

% Balance constraint: X - 2*Y <= 10
constraint matches_x - 2 * matches_y <= max_balance_diff;

% Define total fatigue as linear combination of matches in each sport
constraint total_fatigue = fatigue_x * matches_x + fatigue_y * matches_y;

% Objective
solve minimize total_fatigue;