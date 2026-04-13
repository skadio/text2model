% Parameters (with values embedded)
int: eggs_available = 40;
int: bacon_available = 70;

int: eggs_per_regular = 2;
int: bacon_per_regular = 3;
int: profit_regular = 3;

int: eggs_per_special = 3;
int: bacon_per_special = 5;
int: profit_special = 4;

% Variables
var 0..(eggs_available div eggs_per_regular): regular;
var 0..(eggs_available div eggs_per_special): special;

var 0..(profit_regular * (eggs_available div eggs_per_regular) + profit_special * (eggs_available div eggs_per_special)): total_profit;

% Constraints
constraint eggs_per_regular * regular + eggs_per_special * special <= eggs_available;
constraint bacon_per_regular * regular + bacon_per_special * special <= bacon_available;

constraint total_profit = profit_regular * regular + profit_special * special;

% Objective
solve maximize total_profit;