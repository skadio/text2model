% Printer production optimization (all data embedded)

include "globals.mzn";

% Parameters (given)
int: maxColor = 20;
int: maxBW    = 30;
int: maxTray  = 35;

int: profitColor = 200;
int: profitBW    = 70;

% Decision variables
var 0..maxColor: color;
var 0..maxBW: bw;

% Constraints
constraint color + bw <= maxTray;

% Objective
var int: totalProfit = profitColor * color + profitBW * bw;

solve maximize totalProfit;

output [
  "Color printers = ", show(color), "\n",
  "B/W printers   = ", show(bw), "\n",
  "Total profit   = $", show(totalProfit), "\n"
];