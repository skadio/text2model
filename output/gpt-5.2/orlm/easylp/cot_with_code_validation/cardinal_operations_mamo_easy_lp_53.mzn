% Parameters
int: min_demand = 50;
int: max_stock = 150;

int: profit_x = 10;
int: profit_y = 5;

% Variables
var 0..max_stock: x;  % units of product X
var 0..max_stock: y;  % units of product Y
var 0..(profit_x*max_stock + profit_y*max_stock): total_profit;

% Constraints
constraint 2*x + y >= min_demand;
constraint x + 3*y <= max_stock;

constraint total_profit = profit_x*x + profit_y*y;

% Objective
solve maximize total_profit;