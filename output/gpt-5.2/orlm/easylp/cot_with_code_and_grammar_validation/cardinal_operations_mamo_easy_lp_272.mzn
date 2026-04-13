% Parameters
int: max_total_players = 50;
int: min_YZ = 30;
int: max_XZ = 40;

int: score_X = 3;
int: score_Y = 4;
int: score_Z = 2;

% Variables
var 0..max_total_players: X;
var 0..max_total_players: Y;
var 0..max_total_players: Z;

var 0..(score_X*max_total_players + score_Y*max_total_players + score_Z*max_total_players): total_score;

% Constraints
constraint X + Y + Z <= max_total_players;
constraint Y + Z >= min_YZ;
constraint X + Z <= max_XZ;

constraint total_score = score_X * X + score_Y * Y + score_Z * Z;

% Objective
solve minimize total_score;