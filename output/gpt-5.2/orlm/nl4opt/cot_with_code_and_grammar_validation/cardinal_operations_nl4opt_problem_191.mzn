% Parameters
int: max_time_heating = 300;
int: max_time_cooling = 300;

int: heat_regular = 3;
int: cool_regular = 5;
int: profit_regular = 8;

int: heat_tempered = 5;
int: cool_tempered = 8;
int: profit_tempered = 10;

% Variables
var 0..max_time_heating div heat_regular: x_regular;
var 0..max_time_heating div heat_tempered: x_tempered;

var int: total_profit;

% Constraints
constraint heat_regular * x_regular + heat_tempered * x_tempered <= max_time_heating;
constraint cool_regular * x_regular + cool_tempered * x_tempered <= max_time_cooling;

constraint total_profit = profit_regular * x_regular + profit_tempered * x_tempered;

% Objective
solve maximize total_profit;