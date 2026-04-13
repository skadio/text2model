% Parameters
int: max_total_players = 50;
int: min_YZ = 30;
int: max_XZ = 40;

int: scoreX = 3;
int: scoreY = 4;
int: scoreZ = 2;

% Variables
var 0..max_total_players: X;
var 0..max_total_players: Y;
var 0..max_total_players: Z;

var 0..(scoreX*max_total_players + scoreY*max_total_players + scoreZ*max_total_players): total_score;

% Constraints
constraint X + Y + Z <= max_total_players;
constraint Y + Z >= min_YZ;
constraint X + Z <= max_XZ;

constraint total_score = scoreX*X + scoreY*Y + scoreZ*Z;

% Objective
solve minimize total_score;