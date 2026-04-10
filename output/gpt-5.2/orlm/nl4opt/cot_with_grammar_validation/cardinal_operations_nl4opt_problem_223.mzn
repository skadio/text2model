% Parameters
int: cost_plush = 3;
int: cost_doll = 2;
int: budget = 700;

int: profit_plush = 4;
int: profit_doll = 2;

int: min_plush = 90;
int: max_plush = 190;

% Variables
var 0..max_plush: plush;
var 0..(2*max_plush): doll;

var 0..(profit_plush*max_plush + profit_doll*(2*max_plush)): total_profit;

% Constraints
constraint plush >= min_plush;
constraint plush <= max_plush;

constraint doll <= 2 * plush;

constraint cost_plush * plush + cost_doll * doll <= budget;

constraint total_profit = profit_plush * plush + profit_doll * doll;

% Objective
solve maximize total_profit;