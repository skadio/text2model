% Parameters (with values embedded)
int: milk_available = 30000;
int: honey_available = 500;

int: milk_black = 600;
int: honey_black = 10;
float: profit_black = 7.5;

int: milk_matcha = 525;
int: honey_matcha = 5;
int: profit_matcha_int = 5;

% Variables
var 0..(milk_available div milk_black): x_black;      % bottles of black milk tea
var 0..(milk_available div milk_matcha): x_matcha;    % bottles of matcha milk tea

% Constraints
constraint milk_black * x_black + milk_matcha * x_matcha <= milk_available;
constraint honey_black * x_black + honey_matcha * x_matcha <= honey_available;

% Objective
var float: total_profit = profit_black * int2float(x_black) + int2float(profit_matcha_int * x_matcha);
solve maximize total_profit;