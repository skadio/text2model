% Parameters
int: milk_stock = 30000;
int: honey_stock = 500;

int: milk_black = 600;
int: honey_black = 10;
float: profit_black = 7.5;

int: milk_matcha = 525;
int: honey_matcha = 5;
float: profit_matcha = 5.0;

% Variables
var 0..(milk_stock div milk_black): x_black;
var 0..(milk_stock div milk_matcha): x_matcha;

% Constraints
constraint milk_black * x_black + milk_matcha * x_matcha <= milk_stock;
constraint honey_black * x_black + honey_matcha * x_matcha <= honey_stock;

% Objective
solve maximize profit_black * int2float(x_black) + profit_matcha * int2float(x_matcha);