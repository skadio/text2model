% Store monthly sales optimization: carrots & cucumbers
% All data embedded as required.

include "globals.mzn";

% Parameters (in cents to keep everything integer)
int: budget = 50000;          % $500.00
int: cost_carrot = 30;        % $0.30
int: cost_cucumber = 50;      % $0.50
int: profit_carrot = 75;      % $0.75
int: profit_cucumber = 80;    % $0.80

int: min_carrots = 300;
int: max_carrots = 500;

% Decision variables
var min_carrots..max_carrots: carrots;
var 0..2000: cucumbers;       % safe upper bound

% Constraints
constraint cost_carrot * carrots + cost_cucumber * cucumbers <= budget;
constraint 3 * cucumbers <= carrots;  % cucumbers <= carrots/3

% Objective: maximize profit
var 0..1000000: total_profit;
constraint total_profit = profit_carrot * carrots + profit_cucumber * cucumbers;

solve maximize total_profit;

output [
  "carrots = ", show(carrots), "\n",
  "cucumbers = ", show(cucumbers), "\n",
  "total_profit_cents = ", show(total_profit), "\n",
  "total_profit_dollars = $", show(total_profit div 100), ".", 
    if (total_profit mod 100) < 10 then "0" else "" endif, show(total_profit mod 100), "\n",
  "total_cost_dollars = $", show((cost_carrot*carrots + cost_cucumber*cucumbers) div 100), ".",
    if ((cost_carrot*carrots + cost_cucumber*cucumbers) mod 100) < 10 then "0" else "" endif,
    show((cost_carrot*carrots + cost_cucumber*cucumbers) mod 100), "\n"
];