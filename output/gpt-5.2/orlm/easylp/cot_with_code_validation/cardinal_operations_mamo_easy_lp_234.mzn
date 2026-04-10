% Parameters
int: profit_corn = 3;
int: profit_wheat = 4;
int: profit_soy = 5;

int: lim_cw = 15000;          % 2*Corn + 3*Wheat <= lim_cw
int: min_total_acres = 8000;  % Corn + Wheat + Soy >= min_total_acres
int: max_diff_ws = 2000;      % |Wheat - Soy| <= max_diff_ws

% Variables
var 0..min_total_acres: corn;
var 0..min_total_acres: wheat;
var 0..min_total_acres: soy;

var 0..(profit_soy * min_total_acres): total_profit;

% Constraints
constraint 2 * corn + 3 * wheat <= lim_cw;

constraint corn + wheat + soy >= min_total_acres;

constraint abs(wheat - soy) <= max_diff_ws;

constraint total_profit = profit_corn * corn + profit_wheat * wheat + profit_soy * soy;

% Objective
solve minimize total_profit;