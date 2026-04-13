% Parameters
% Resource requirements per bottle (grams)
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

% Upper bounds on production (safe integer bounds from resource limits)
int: max_black  = min(milk_stock div milk_per_black, honey_stock div honey_per_black);
int: max_matcha = min(milk_stock div milk_per_matcha, honey_stock div honey_per_matcha);

% Variables
var 0..max_black:  bottles_black;   % number of black milk tea bottles to produce
var 0..max_matcha: bottles_matcha;  % number of matcha milk tea bottles to produce

var float: total_profit;            % total profit to maximize

% Constraints
% Resource capacity constraints (do not exceed available stock)
constraint
  milk_per_black * bottles_black + milk_per_matcha * bottles_matcha <= milk_stock;

constraint
  honey_per_black * bottles_black + honey_per_matcha * bottles_matcha <= honey_stock;

% Total profit definition (link profit variable to decision variables)
constraint
  total_profit =
    profit_black  * int2float(bottles_black) +
    profit_matcha * int2float(bottles_matcha);

% Objective
solve maximize total_profit;