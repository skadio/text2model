% Parameters
int: total_cap = 100;
int: min_diverse = 50;              % 2*X + Y >= 50
int: profit_x = 5;
int: profit_y = 3;
int: max_x = 60;
int: max_y = 70;

% Variables
var 0..max_x: X;
var 0..max_y: Y;

% Constraints
constraint X + Y <= total_cap;
constraint 2*X + Y >= min_diverse;

% Objective
var int: total_profit = profit_x * X + profit_y * Y;
solve maximize total_profit;