% Toy store inventory / sales profit maximization
% All data embedded as per instructions.

include "globals.mzn";

% Parameters (from problem statement)
int: cost_plush = 3;
int: cost_doll  = 2;
int: budget     = 700;

int: profit_plush = 4;
int: profit_doll  = 2;

int: plush_min = 90;
int: plush_max = 190;

% Decision variables: quantities bought and sold (assumed bought = sold per month)
var plush_min..plush_max: plush;
var 0..2*plush_max: dolls;

% Constraints
constraint cost_plush * plush + cost_doll * dolls <= budget;
constraint dolls <= 2 * plush;

% Objective: maximize profit
var int: total_profit = profit_plush * plush + profit_doll * dolls;

solve maximize total_profit;

output [
  "plush = ", show(plush), "\n",
  "dolls = ", show(dolls), "\n",
  "budget_used = ", show(cost_plush * plush + cost_doll * dolls), "\n",
  "profit = ", show(total_profit), "\n"
];