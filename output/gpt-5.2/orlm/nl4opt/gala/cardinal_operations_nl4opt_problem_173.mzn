include "globals.mzn";

% Data (embedded from description)
int: max_units = 200;
int: budget = 300000;

int: cost_premium = 2000;
int: cost_regular = 1000;

int: profit_premium = 500;
int: profit_regular = 300;

% Decision variables
var 0..max_units: premium;   % number of premium desktops
var 0..max_units: regular;   % number of regular desktops

% Constraints
constraint premium + regular <= max_units;
constraint cost_premium * premium + cost_regular * regular <= budget;

% Objective
var int: total_profit = profit_premium * premium + profit_regular * regular;
solve maximize total_profit;

% Output
output [
  "premium = ", show(premium), "\n",
  "regular = ", show(regular), "\n",
  "total_profit = ", show(total_profit), "\n"
];