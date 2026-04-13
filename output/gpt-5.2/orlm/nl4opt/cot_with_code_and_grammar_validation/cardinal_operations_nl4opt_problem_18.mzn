% Parameters
int: wood_per_elephant = 50;
int: plastic_per_elephant = 20;
int: wood_per_tiger = 40;
int: plastic_per_tiger = 30;

int: wood_available = 5000;
int: plastic_available = 4000;

int: profit_elephant = 5;
int: profit_tiger = 4;

% Variables
var 0..(wood_available div wood_per_elephant): elephants;
var 0..(wood_available div wood_per_tiger): tigers;

% Constraints
constraint wood_per_elephant * elephants + wood_per_tiger * tigers <= wood_available;
constraint plastic_per_elephant * elephants + plastic_per_tiger * tigers <= plastic_available;

% Objective
var int: total_profit = profit_elephant * elephants + profit_tiger * tigers;
solve maximize total_profit;