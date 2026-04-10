% Parameters
int: total_acres = 50;
int: min_apples = 5;
int: min_pears = 10;

int: profit_apples = 2;
int: profit_pears = 4;

% Variables
var min_apples..total_acres: apples;
var min_pears..total_acres: pears;

var 0..(profit_apples * total_acres + profit_pears * total_acres): profit;

% Constraints
constraint apples + pears <= total_acres;
constraint pears >= apples;
constraint pears <= 2 * apples;

constraint profit = profit_apples * apples + profit_pears * pears;

% Objective
solve maximize profit;