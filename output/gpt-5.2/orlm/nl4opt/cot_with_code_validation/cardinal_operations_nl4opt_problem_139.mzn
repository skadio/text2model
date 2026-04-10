% Parameters
int: eggs_per_regular = 2;
int: bacon_per_regular = 3;
int: eggs_per_special = 3;
int: bacon_per_special = 5;

int: total_eggs = 40;
int: total_bacon = 70;

int: profit_regular = 3;
int: profit_special = 4;

% Variables
var 0..(total_eggs div eggs_per_regular): regular;
var 0..(total_eggs div eggs_per_special): special;

var int: profit;

% Constraints
constraint eggs_per_regular * regular + eggs_per_special * special <= total_eggs;
constraint bacon_per_regular * regular + bacon_per_special * special <= total_bacon;

constraint profit = profit_regular * regular + profit_special * special;

% Objective
solve maximize profit;