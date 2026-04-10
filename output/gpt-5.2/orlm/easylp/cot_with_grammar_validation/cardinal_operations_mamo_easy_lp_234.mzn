% Parameters
int: profit_corn = 3;
int: profit_wheat = 4;
int: profit_soy = 5;

int: cap_corn_wheat = 15000;
int: min_total_acres = 8000;
int: max_diff_wheat_soy = 2000;

% Variables
var 0..cap_corn_wheat: corn;
var 0..cap_corn_wheat: wheat;
var 0..cap_corn_wheat: soy;

var 0..(profit_soy * min_total_acres): total_profit;

% Constraints
constraint 2 * corn + 3 * wheat <= cap_corn_wheat;
constraint corn + wheat + soy >= min_total_acres;
constraint abs(wheat - soy) <= max_diff_wheat_soy;

constraint total_profit = profit_corn * corn + profit_wheat * wheat + profit_soy * soy;

% Objective
solve minimize total_profit;