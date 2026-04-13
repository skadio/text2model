% Parameters
int: cost_plush = 3;
int: cost_doll  = 2;
int: budget = 700;

int: profit_plush = 4;
int: profit_doll  = 2;

int: min_plush = 90;
int: max_plush = 190;

% Variables
var 0..max_plush: plush;
var 0..2*max_plush: doll;

% Constraints
constraint plush >= min_plush;
constraint plush <= max_plush;

constraint cost_plush * plush + cost_doll * doll <= budget;

constraint doll <= 2 * plush;

% Objective
solve maximize profit_plush * plush + profit_doll * doll;