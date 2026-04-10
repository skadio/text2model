% Parameters (with values embedded)
int: profit_wheat = 5;
int: profit_corn  = 3;
int: limit_total  = 1000;
int: min_diff     = 100;

% Variables
var 0..limit_total: wheat;
var 0..limit_total: corn;
var int: profit;

% Constraints
constraint 2 * wheat + 4 * corn <= limit_total;
constraint wheat - corn >= min_diff;
constraint profit = profit_wheat * wheat + profit_corn * corn;

% Objective
solve minimize profit;