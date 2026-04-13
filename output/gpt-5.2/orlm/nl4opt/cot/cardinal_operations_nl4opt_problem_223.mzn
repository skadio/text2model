% Parameters (with values embedded)
int: cost_plush = 3;
int: cost_doll  = 2;
int: budget = 700;

int: profit_plush = 4;
int: profit_doll  = 2;

int: plush_min = 90;
int: plush_max = 190;

% Variables
var 0..plush_max: plush;                 % number of plush toys bought/sold
var 0..(2*plush_max): dolls;             % number of dolls bought/sold (bounded via dolls <= 2*plush)

% Constraints
constraint plush >= plush_min;
constraint plush <= plush_max;

constraint cost_plush * plush + cost_doll * dolls <= budget;

constraint dolls <= 2 * plush;

% Objective
solve maximize profit_plush * plush + profit_doll * dolls;