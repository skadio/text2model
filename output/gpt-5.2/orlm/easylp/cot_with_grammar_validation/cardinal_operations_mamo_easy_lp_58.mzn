% Parameters
int: max_total_units = 100;
int: min_diversity = 50;          % 2*X + Y >= 50
int: profit_x = 5;
int: profit_y = 3;
int: max_x = 60;
int: max_y = 70;

% Variables
var 0..max_x: x;
var 0..max_y: y;
var 0..(profit_x*max_x + profit_y*max_y): total_profit;

% Constraints
constraint x + y <= max_total_units;
constraint 2*x + y >= min_diversity;
constraint total_profit = profit_x*x + profit_y*y;

% Objective
solve maximize total_profit;