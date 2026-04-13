% Parameters (with values embedded)
int: max_total_units = 100;
int: min_diversity = 50;           % 2*X + Y >= 50
int: profit_X = 5;
int: profit_Y = 3;
int: max_X = 60;
int: max_Y = 70;

% Variables
var 0..max_X: X;
var 0..max_Y: Y;
var 0..(profit_X*max_X + profit_Y*max_Y): total_profit;

% Constraints
constraint X + Y <= max_total_units;
constraint 2*X + Y >= min_diversity;
constraint total_profit = profit_X*X + profit_Y*Y;

% Objective
solve maximize total_profit;