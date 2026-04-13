% Parameters
% Resource usage per bottle (grams)
int: milk_per_black   = 600;
int: honey_per_black  = 10;
int: milk_per_matcha  = 525;
int: honey_per_matcha = 5;

% Available stock (grams)
int: milk_stock  = 30000;
int: honey_stock = 500;

% Profit per bottle (dollars)
float: profit_black  = 7.5;
float: profit_matcha = 5.0;

% Safe upper bounds on decision variables (computed from resource limits)
int: max_black  = min(milk_stock div milk_per_black,  honey_stock div honey_per_black);
int: max_matcha = min(milk_stock div milk_per_matcha, honey_stock div honey_per_matcha);

% Variables
% Number of bottles to produce (nonnegative integers)
var 0..max_black:  bottles_black;
var 0..max_matcha: bottles_matcha;

% Total profit to maximize
var float: total_profit;

% Constraints
% Resource constraints: do not exceed available milk stock
constraint
  milk_per_black * bottles_black + milk_per_matcha * bottles_matcha
  <= milk_stock;

% Resource constraints: do not exceed available honey stock
constraint
  honey_per_black * bottles_black + honey_per_matcha * bottles_matcha
  <= honey_stock;

% Profit definition: link total_profit to decision variables (ensure float consistency)
constraint
  total_profit
  = profit_black * int2float(bottles_black)
  + profit_matcha * int2float(bottles_matcha);

% Objective
solve maximize total_profit;