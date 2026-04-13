% Inventory optimization for phones and laptops (LP as MIP with integer stock)
% Maximize profit subject to floor space, budget, and mix requirements.

int: profit_phone = 120;
int: profit_laptop = 40;

int: space_phone = 1;
int: space_laptop = 4;
int: total_space = 400;

int: cost_phone = 400;
int: cost_laptop = 100;
int: budget = 6000;

% Decision variables: quantities to stock
var 0..10000: phones;
var 0..10000: laptops;

% Floor space constraint
constraint space_phone * phones + space_laptop * laptops <= total_space;

% Budget constraint
constraint cost_phone * phones + cost_laptop * laptops <= budget;

% At least 80% of all items are laptops:
% laptops >= 0.8*(phones + laptops)  <=>  5*laptops >= 4*(phones + laptops)  <=>  laptops >= 4*phones
constraint laptops >= 4 * phones;

% Objective: maximize total profit
var int: total_profit = profit_phone * phones + profit_laptop * laptops;
solve maximize total_profit;

output [
  "phones=", show(phones), "\n",
  "laptops=", show(laptops), "\n",
  "total_profit=", show(total_profit), "\n"
];