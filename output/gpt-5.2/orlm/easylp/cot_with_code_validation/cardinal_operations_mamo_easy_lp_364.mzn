% Parameters
int: profit_wheat = 4;
int: profit_corn = 3;
int: profit_soy = 2;
int: profit_rice = 1;

int: max_wc = 1000;
int: max_sr = 800;

int: min_wheat_minus_soy = 200;
int: max_diff_corn_rice = 500;

int: max_wheat = 600;
int: max_corn = 400;
int: max_soy = 350;
int: max_rice = 300;

% Variables
var 0..max_wheat: wheat;
var 0..max_corn: corn;
var 0..max_soy: soy;
var 0..max_rice: rice;

var int: total_profit;

% Constraints
constraint wheat + corn <= max_wc;
constraint soy + rice <= max_sr;

constraint wheat - soy >= min_wheat_minus_soy;
constraint abs(corn - rice) <= max_diff_corn_rice;

constraint total_profit = profit_wheat * wheat
                        + profit_corn * corn
                        + profit_soy * soy
                        + profit_rice * rice;

% Objective
solve maximize total_profit;