% Parameters
int: gold_available = 1000;
int: gold_per_long = 10;
int: gold_per_short = 7;

int: profit_long = 12;
int: profit_short = 5;

int: short_at_least_factor = 5; % short >= factor * long
int: min_long = 10;

% Variables
var 0..(gold_available div gold_per_long): long_cables;
var 0..(gold_available div gold_per_short): short_cables;

var 0..(profit_long * (gold_available div gold_per_long) + profit_short * (gold_available div gold_per_short)): total_profit;

% Constraints
constraint gold_per_long * long_cables + gold_per_short * short_cables <= gold_available;

constraint short_cables >= short_at_least_factor * long_cables;

constraint long_cables >= min_long;

constraint total_profit = profit_long * long_cables + profit_short * short_cables;

% Objective
solve maximize total_profit;