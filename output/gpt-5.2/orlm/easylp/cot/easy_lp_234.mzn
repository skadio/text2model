% Parameters (with values embedded)
int: profit_corn = 3;
int: profit_wheat = 4;
int: profit_soy   = 5;

int: limit_soil = 15000;
int: min_total_acres = 8000;
int: max_diff_ws = 2000;

% Variables
var 0..15000: corn;
var 0..15000: wheat;
var 0..15000: soybean;

% Constraints
constraint 2 * corn + 3 * wheat <= limit_soil;
constraint corn + wheat + soybean >= min_total_acres;
constraint abs(wheat - soybean) <= max_diff_ws;

% Objective
var int: total_profit = profit_corn * corn + profit_wheat * wheat + profit_soy * soybean;
solve minimize total_profit;