% Parameters
int: max_total_players = 50;          % Upper bound on total allocated players
int: min_YZ_players    = 30;          % Minimum combined players in teams Y and Z
int: max_XZ_players    = 40;          % Maximum combined players in teams X and Z

int: score_X = 3;                     % Performance score per player assigned to team X
int: score_Y = 4;                     % Performance score per player assigned to team Y
int: score_Z = 2;                     % Performance score per player assigned to team Z

% Variables
var 0..max_total_players: players_X;  % Number of players assigned to team X
var 0..max_total_players: players_Y;  % Number of players assigned to team Y
var 0..max_total_players: players_Z;  % Number of players assigned to team Z

% Upper bound: max_total_players allocated, all to the highest score team (Y)
var 0..(score_X*max_total_players + score_Y*max_total_players + score_Z*max_total_players): total_score;

% Constraints
% Total players capacity constraint
constraint players_X + players_Y + players_Z <= max_total_players;

% Minimum combined players in teams Y and Z
constraint players_Y + players_Z >= min_YZ_players;

% Maximum combined players in teams X and Z
constraint players_X + players_Z <= max_XZ_players;

% Define total performance score from team allocations
constraint total_score = score_X * players_X + score_Y * players_Y + score_Z * players_Z;

% Objective
solve minimize total_score;