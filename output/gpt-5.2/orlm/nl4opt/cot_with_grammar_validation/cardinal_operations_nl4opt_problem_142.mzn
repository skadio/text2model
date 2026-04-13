% Parameters
int: paint_avail = 100;
int: glitter_avail = 50;
int: glue_avail = 70;

int: paint_large = 4;
int: glitter_large = 3;
int: glue_large = 5;

int: paint_small = 2;
int: glitter_small = 1;
int: glue_small = 2;

int: min_large = 5;
int: min_small = 5;

int: profit_large = 30;
int: profit_small = 15;

% Variables
var min_large..(paint_avail div paint_large): large;
var min_small..(paint_avail div paint_small): small;

var 0..(profit_large*(paint_avail div paint_large) + profit_small*(paint_avail div paint_small)): profit;

% Constraints
constraint paint_large * large + paint_small * small <= paint_avail;
constraint glitter_large * large + glitter_small * small <= glitter_avail;
constraint glue_large * large + glue_small * small <= glue_avail;

constraint profit = profit_large * large + profit_small * small;

% Objective
solve maximize profit;