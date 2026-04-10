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
var min_large..(paint_avail div paint_large): x_large;
var min_small..(paint_avail div paint_small): x_small;

var 0..(profit_large*(paint_avail div paint_large) + profit_small*(paint_avail div paint_small)): total_profit;

% Constraints
constraint paint_large * x_large + paint_small * x_small <= paint_avail;
constraint glitter_large * x_large + glitter_small * x_small <= glitter_avail;
constraint glue_large * x_large + glue_small * x_small <= glue_avail;

constraint total_profit = profit_large * x_large + profit_small * x_small;

% Objective
solve maximize total_profit;