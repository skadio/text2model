% Parameters
int: total_acres = 50;
int: min_apples = 5;
int: min_pears = 10;
int: profit_apple = 2;
int: profit_pear = 4;
int: max_pears_per_apple_ratio = 2;

% Variables
var min_apples..total_acres: apples;
var min_pears..total_acres: pears;
var 0..(profit_apple*total_acres + profit_pear*total_acres): profit;

% Constraints
constraint apples + pears <= total_acres;

constraint pears >= apples;
constraint pears <= max_pears_per_apple_ratio * apples;

constraint profit = profit_apple * apples + profit_pear * pears;

% Objective
solve maximize profit;