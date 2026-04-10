% Fruit salad production optimization (integer model)
include "globals.mzn";

% ----- Data (embedded as requested) -----
int: stock_mango = 25;
int: stock_pine  = 10;
int: stock_straw = 120;

% Per-unit usage (scaled to avoid fractions)
% A uses: 1/4 mango, 1/8 pineapple, 3 strawberries
% B uses: 1/2 mango, 1/4 pineapple, 1 strawberry
% LCM of denominators for mango/pine is 8, so scale mango & pineapple by 8:
int: a_mango8 = 2;   % (1/4)*8
int: b_mango8 = 4;   % (1/2)*8
int: a_pine8  = 1;   % (1/8)*8
int: b_pine8  = 2;   % (1/4)*8
int: a_straw  = 3;
int: b_straw  = 1;

int: profitA = 10;
int: profitB = 20;

% Tolerance: at most 5 units left or 5 additional units used for each fruit
int: tol = 5;

% ----- Decision variables -----
var 0..10000: xA;  % units of salad A
var 0..10000: xB;  % units of salad B

% Deviations from stock (can be negative = leftover, positive = overuse)
var -tol..tol: dev_mango8;  % in "eighth-mango" units
var -tol..tol: dev_pine8;   % in "eighth-pineapple" units
var -tol..tol: dev_straw;   % in strawberries

% ----- Constraints -----
% Resource balance with tolerance (use = stock + deviation)
constraint a_mango8 * xA + b_mango8 * xB = 8 * stock_mango + dev_mango8;
constraint a_pine8  * xA + b_pine8  * xB = 8 * stock_pine  + dev_pine8;
constraint a_straw  * xA + b_straw  * xB = stock_straw     + dev_straw;

% ----- Objective -----
var int: total_profit = profitA * xA + profitB * xB;
solve maximize total_profit;

% ----- Output -----
output [
  "xA = ", show(xA), "\n",
  "xB = ", show(xB), "\n",
  "total_profit = ", show(total_profit), "\n",
  "mango deviation (in eighths) = ", show(dev_mango8), "  (=", show(dev_mango8 / 8.0), " mangoes)\n",
  "pine deviation (in eighths)  = ", show(dev_pine8),  "  (=", show(dev_pine8 / 8.0),  " pineapples)\n",
  "strawberry deviation         = ", show(dev_straw), "\n"
];