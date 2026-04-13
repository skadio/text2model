% Parameters
int: max_total_players = 50;
int: min_yz_players = 30;
int: max_xz_players = 40;

int: score_x = 3;
int: score_y = 4;
int: score_z = 2;

% Variables
var 0..max_total_players: x;
var 0..max_total_players: y;
var 0..max_total_players: z;

var 0..(score_x*max_total_players + score_y*max_total_players + score_z*max_total_players): total_score;

% Constraints
constraint x + y + z <= max_total_players;
constraint y + z >= min_yz_players;
constraint x + z <= max_xz_players;

constraint total_score = score_x*x + score_y*y + score_z*z;

% Objective
solve minimize total_score;