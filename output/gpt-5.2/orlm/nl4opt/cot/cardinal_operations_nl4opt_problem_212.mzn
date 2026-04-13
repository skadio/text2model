% Parameters (with values embedded)
int: stock_apples = 10;
int: stock_bananas = 20;
int: stock_grapes = 80;

int: apples_bh = 6;
int: bananas_bh = 0;
int: grapes_bh = 30;
int: profit_bh = 6;

int: apples_combo = 5;
int: bananas_combo = 6;
int: grapes_combo = 20;
int: profit_combo = 7;

% Variables
var 0..(stock_apples div min(apples_bh, apples_combo)): x_bh;      % banana-haters packages
var 0..(stock_apples div min(apples_bh, apples_combo)): x_combo;  % combo packages

% Constraints
constraint apples_bh * x_bh + apples_combo * x_combo <= stock_apples;
constraint bananas_bh * x_bh + bananas_combo * x_combo <= stock_bananas;
constraint grapes_bh * x_bh + grapes_combo * x_combo <= stock_grapes;

% Objective
var int: total_profit = profit_bh * x_bh + profit_combo * x_combo;
solve maximize total_profit;

output [
  "banana_haters_packages = ", show(x_bh), "\n",
  "combo_packages = ", show(x_combo), "\n",
  "total_profit = ", show(total_profit), "\n"
];