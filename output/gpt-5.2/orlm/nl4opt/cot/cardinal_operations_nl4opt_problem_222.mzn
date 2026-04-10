% Parameters (with values embedded)
int: gold_available = 1000;
int: gold_long = 10;
int: gold_short = 7;

int: min_long = 10;
int: short_to_long_ratio = 5;

int: profit_long = 12;
int: profit_short = 5;

% Variables
var 0..(gold_available div gold_long): long_cables;
var 0..(gold_available div gold_short): short_cables;

% Constraints
constraint long_cables >= min_long;
constraint short_cables >= short_to_long_ratio * long_cables;
constraint gold_long * long_cables + gold_short * short_cables <= gold_available;

% Objective
solve maximize profit_long * long_cables + profit_short * short_cables;