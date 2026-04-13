% Milk tea production optimization (all data embedded)

int: milk_stock = 30000;      % grams
int: honey_stock = 500;       % grams

int: milk_black = 600;        % grams per bottle
int: honey_black = 10;        % grams per bottle
float: profit_black = 7.5;    % dollars per bottle

int: milk_matcha = 525;       % grams per bottle
int: honey_matcha = 5;        % grams per bottle
int: profit_matcha = 5;       % dollars per bottle

% Decision variables: number of bottles (nonnegative integers)
var 0..milk_stock div min(milk_black, milk_matcha): black;
var 0..milk_stock div min(milk_black, milk_matcha): matcha;

% Resource constraints
constraint milk_black * black + milk_matcha * matcha <= milk_stock;
constraint honey_black * black + honey_matcha * matcha <= honey_stock;

% Objective: maximize profit (use scaled integer to avoid float objective)
var int: profit_cents = 750 * black + 500 * matcha;

solve maximize profit_cents;

output [
  "black_bottles=", show(black), "\n",
  "matcha_bottles=", show(matcha), "\n",
  "max_profit=$", show(profit_cents div 100), ".", show(profit_cents mod 100), "\n"
];