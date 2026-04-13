% Parameters
int: gold_available = 1000;
int: gold_long = 10;
int: gold_short = 7;

int: profit_long = 12;
int: profit_short = 5;

int: min_long = 10;
int: short_at_least_factor = 5;

% Variables
var 0..(gold_available div gold_long): n_long;
var 0..(gold_available div gold_short): n_short;

% Constraints
constraint gold_long * n_long + gold_short * n_short <= gold_available;

constraint n_short >= short_at_least_factor * n_long;

constraint n_long >= min_long;

% Objective
solve maximize profit_long * n_long + profit_short * n_short;