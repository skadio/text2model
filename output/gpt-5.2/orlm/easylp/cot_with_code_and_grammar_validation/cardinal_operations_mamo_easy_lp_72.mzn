% Parameters
int: profit_wheat = 5;
int: profit_corn  = 3;
int: limit = 1000;
int: wheat_coeff = 2;
int: corn_coeff  = 4;
int: min_wheat_minus_corn = 100;

% Variables
var 0..limit: wheat;
var 0..limit: corn;
var 0..(profit_wheat*limit + profit_corn*limit): profit;

% Constraints
constraint wheat_coeff * wheat + corn_coeff * corn <= limit;
constraint wheat - corn >= min_wheat_minus_corn;
constraint profit = profit_wheat * wheat + profit_corn * corn;

% Objective
solve minimize profit;