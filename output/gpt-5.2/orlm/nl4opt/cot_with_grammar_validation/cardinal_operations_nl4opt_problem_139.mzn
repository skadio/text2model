% Parameters
int: eggs_per_regular = 2;
int: bacon_per_regular = 3;
int: eggs_per_special = 3;
int: bacon_per_special = 5;

int: eggs_total = 40;
int: bacon_total = 70;

int: profit_regular = 3;
int: profit_special = 4;

% Variables
var 0..(eggs_total div eggs_per_regular): regular;
var 0..(eggs_total div eggs_per_special): special;
var 0..(profit_regular * (eggs_total div eggs_per_regular) + profit_special * (eggs_total div eggs_per_special)): profit;

% Constraints
constraint eggs_per_regular * regular + eggs_per_special * special <= eggs_total;
constraint bacon_per_regular * regular + bacon_per_special * special <= bacon_total;

constraint profit = profit_regular * regular + profit_special * special;

% Objective
solve maximize profit;