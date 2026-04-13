include "globals.mzn";

% Data (embedded from problem statement)
int: gold_available = 1000;     % mg
int: gold_long = 10;           % mg per long cable
int: gold_short = 7;           % mg per short cable
int: min_long = 10;            % at least 10 long cables
int: short_at_least_factor = 5;% short >= 5 * long
int: profit_long = 12;         % $ per long cable
int: profit_short = 5;         % $ per short cable

% Decision variables
var 0..gold_available div gold_long: long;      % upper bound by gold
var 0..gold_available div gold_short: short;

% Constraints
constraint gold_long * long + gold_short * short <= gold_available;
constraint short >= short_at_least_factor * long;
constraint long >= min_long;

% Objective
var int: profit = profit_long * long + profit_short * short;
solve maximize profit;

output [
  "long = ", show(long), "\n",
  "short = ", show(short), "\n",
  "gold_used = ", show(gold_long*long + gold_short*short), " mg\n",
  "profit = $", show(profit), "\n"
];