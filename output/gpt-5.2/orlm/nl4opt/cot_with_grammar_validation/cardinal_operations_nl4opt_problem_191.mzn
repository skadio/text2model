% Parameters
int: max_minutes = 300;

int: heat_regular = 3;
int: cool_regular = 5;

int: heat_tempered = 5;
int: cool_tempered = 8;

int: profit_regular = 8;
int: profit_tempered = 10;

% Variables
var 0..(max_minutes div heat_regular): x_regular;
var 0..(max_minutes div heat_tempered): x_tempered;

var 0..(profit_regular * (max_minutes div heat_regular) + profit_tempered * (max_minutes div heat_tempered)): total_profit;

% Constraints
constraint heat_regular * x_regular + heat_tempered * x_tempered <= max_minutes;
constraint cool_regular * x_regular + cool_tempered * x_tempered <= max_minutes;

constraint total_profit = profit_regular * x_regular + profit_tempered * x_tempered;

% Objective
solve maximize total_profit;