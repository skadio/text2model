% Parameters (with values embedded)
int: max_regular = 50;
int: max_deluxe  = 40;
int: max_total   = 70;

% Use cents to keep the objective integer
int: profit_regular = 250; % $2.50
int: profit_deluxe  = 355; % $3.55

% Variables
var 0..max_regular: x1; % regular tacos
var 0..max_deluxe:  x2; % deluxe tacos

% Constraints
constraint x1 + x2 <= max_total;

% Objective
solve maximize profit_regular * x1 + profit_deluxe * x2;