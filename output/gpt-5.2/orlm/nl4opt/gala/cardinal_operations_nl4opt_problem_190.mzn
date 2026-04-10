% Milk tea production optimization (integer linear programming)

% Data (embedded from problem statement)
int: milk_stock = 30000;     % grams
int: honey_stock = 500;      % grams

int: milk_black = 600;       % grams per bottle
int: honey_black = 10;       % grams per bottle
int: milk_matcha = 525;      % grams per bottle
int: honey_matcha = 5;       % grams per bottle

% Profits in cents to avoid floating point
int: profit_black = 750;     % $7.50
int: profit_matcha = 500;    % $5.00

% Decision variables: number of bottles
var 0..milk_stock div milk_black: black;
var 0..milk_stock div milk_matcha: matcha;

% Resource constraints
constraint milk_black * black + milk_matcha * matcha <= milk_stock;
constraint honey_black * black + honey_matcha * matcha <= honey_stock;

% Objective (maximize total profit)
var int: total_profit = profit_black * black + profit_matcha * matcha;

solve maximize total_profit;

output [
  "black bottles = ", show(black), "\n",
  "matcha bottles = ", show(matcha), "\n",
  "total profit = $", show(total_profit div 100), ".", 
  if (total_profit mod 100) < 10 then "0" else "" endif, show(total_profit mod 100), "\n",
  "milk used (g) = ", show(milk_black * black + milk_matcha * matcha), " / ", show(milk_stock), "\n",
  "honey used (g) = ", show(honey_black * black + honey_matcha * matcha), " / ", show(honey_stock), "\n"
];