% Parameters
int: cost_plush = 3;
int: cost_doll  = 2;
int: budget = 700;

int: profit_plush = 4;
int: profit_doll  = 2;

int: plush_min = 90;
int: plush_max = 190;

% Variables
var 0..plush_max: plush;
var 0..2*plush_max: dolls;

% Constraints
constraint cost_plush * plush + cost_doll * dolls <= budget;

constraint plush >= plush_min;
constraint plush <= plush_max;

constraint dolls <= 2 * plush;

% Objective
solve maximize profit_plush * plush + profit_doll * dolls;