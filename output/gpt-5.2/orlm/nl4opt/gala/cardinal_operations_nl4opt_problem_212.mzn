% Grocery package production planning (integer linear optimization)

include "globals.mzn";

% Stock available
int: stock_apples  = 10;
int: stock_bananas = 20;
int: stock_grapes  = 80;

% Package 1: banana-haters
int: a1 = 6;
int: b1 = 0;
int: g1 = 30;
int: p1 = 6;

% Package 2: combo
int: a2 = 5;
int: b2 = 6;
int: g2 = 20;
int: p2 = 7;

% Decision variables: number of each package to prepare
var 0..stock_apples:  x1;  % banana-haters packages
var 0..stock_apples:  x2;  % combo packages

% Resource constraints (cannot exceed stock)
constraint a1*x1 + a2*x2 <= stock_apples;
constraint b1*x1 + b2*x2 <= stock_bananas;
constraint g1*x1 + g2*x2 <= stock_grapes;

% Objective: maximize profit
var int: profit = p1*x1 + p2*x2;
solve maximize profit;

output [
  "Banana-haters packages (x1) = ", show(x1), "\n",
  "Combo packages (x2)         = ", show(x2), "\n",
  "Profit                      = ", show(profit), " euros\n",
  "Used apples  = ", show(a1*x1 + a2*x2), " / ", show(stock_apples), "\n",
  "Used bananas = ", show(b1*x1 + b2*x2), " / ", show(stock_bananas), "\n",
  "Used grapes  = ", show(g1*x1 + g2*x2), " / ", show(stock_grapes), "\n"
];