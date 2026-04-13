% Parameters
int: profit_corn = 3;
int: profit_wheat = 4;
int: profit_soy = 5;

int: limit_corn_wheat = 15000;     % 2*corn + 3*wheat <= 15000
int: min_total_acres = 8000;       % corn + wheat + soy >= 8000
int: max_diff_wheat_soy = 2000;    % |wheat - soy| <= 2000

% Variables
var 0..limit_corn_wheat div 2: corn;
var 0..limit_corn_wheat div 3: wheat;
var 0..min_total_acres + max_diff_wheat_soy + limit_corn_wheat: soy;

var int: total_profit;

% Constraints
constraint 2*corn + 3*wheat <= limit_corn_wheat;
constraint corn + wheat + soy >= min_total_acres;
constraint abs(wheat - soy) <= max_diff_wheat_soy;

constraint total_profit = profit_corn*corn + profit_wheat*wheat + profit_soy*soy;

% Objective
solve minimize total_profit;