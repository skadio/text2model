% Parameters
int: total_acres = 50;
int: min_apples = 5;
int: min_pears = 10;
int: profit_apple = 2;
int: profit_pear = 4;
int: pear_to_apple_ratio_max = 2;

% Variables
var 0..total_acres: apples;
var 0..total_acres: pears;
var 0..(profit_apple * total_acres + profit_pear * total_acres): profit;

% Constraints
constraint apples + pears <= total_acres;
constraint apples >= min_apples;
constraint pears >= min_pears;

constraint pears >= apples;
constraint pears <= pear_to_apple_ratio_max * apples;

constraint profit = profit_apple * apples + profit_pear * pears;

% Objective
solve maximize profit;