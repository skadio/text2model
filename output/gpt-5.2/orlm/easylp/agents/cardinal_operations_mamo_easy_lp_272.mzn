% Parameters
int: max_total_players = 50;          % Upper bound on total players allocated (X+Y+Z)
int: min_yz_players    = 30;          % Minimum required players in teams Y and Z combined
int: max_xz_players    = 40;          % Maximum allowed players in teams X and Z combined

int: score_x = 3;                     % Performance score per player assigned to team X
int: score_y = 4;                     % Performance score per player assigned to team Y
int: score_z = 2;                     % Performance score per player assigned to team Z


% Variables
var 0..max_total_players: players_x;  % Number of players assigned to team X
var 0..max_total_players: players_y;  % Number of players assigned to team Y
var 0..max_total_players: players_z;  % Number of players assigned to team Z

% Total performance score (upper bound is the maximum possible if all 50 players were in the highest-scoring team)
var 0..(score_x*max_total_players + score_y*max_total_players + score_z*max_total_players): total_score;


% Constraints
% Total players capacity constraint (X + Y + Z <= max_total_players)
constraint players_x + players_y + players_z <= max_total_players;

% Minimum combined players in teams Y and Z (Y + Z >= min_yz_players)
constraint players_y + players_z >= min_yz_players;

% Maximum combined players in teams X and Z (X + Z <= max_xz_players)
constraint players_x + players_z <= max_xz_players;

% Define total performance score from team allocations
constraint total_score = score_x * players_x + score_y * players_y + score_z * players_z;


% Objective
solve minimize total_score;