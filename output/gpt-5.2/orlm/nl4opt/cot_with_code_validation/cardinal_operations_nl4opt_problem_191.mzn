% Parameters
int: max_minutes = 300;

int: heat_reg = 3;
int: cool_reg = 5;

int: heat_temp = 5;
int: cool_temp = 8;

int: profit_reg = 8;
int: profit_temp = 10;

% Variables
var 0..max_minutes: x_reg;   % number of regular panes
var 0..max_minutes: x_temp;  % number of tempered panes

var 0..(profit_reg*max_minutes + profit_temp*max_minutes): total_profit;

% Constraints
constraint heat_reg * x_reg + heat_temp * x_temp <= max_minutes;
constraint cool_reg * x_reg + cool_temp * x_temp <= max_minutes;

constraint total_profit = profit_reg * x_reg + profit_temp * x_temp;

% Objective
solve maximize total_profit;