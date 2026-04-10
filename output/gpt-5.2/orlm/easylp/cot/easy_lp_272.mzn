% Parameters (with values embedded)
int: max_total_players = 50;
int: min_YZ = 30;
int: max_XZ = 40;

int: score_X = 3;
int: score_Y = 4;
int: score_Z = 2;

% Variables
var 0..max_total_players: x; % players in team X
var 0..max_total_players: y; % players in team Y
var 0..max_total_players: z; % players in team Z

var 0..(score_X*max_total_players + score_Y*max_total_players + score_Z*max_total_players): total_score;

% Constraints
constraint x + y + z <= max_total_players;
constraint y + z >= min_YZ;
constraint x + z <= max_XZ;

constraint total_score = score_X*x + score_Y*y + score_Z*z;

% Objective
solve minimize total_score;