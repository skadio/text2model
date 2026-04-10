% Cable production optimization (all data embedded)

int: gold_available = 1000;

int: gold_long = 10;
int: gold_short = 7;

int: profit_long = 12;
int: profit_short = 5;

int: min_long = 10;

var 0..gold_available div gold_long: long_cables;
var 0..gold_available div gold_short: short_cables;

constraint long_cables >= min_long;

% Gold usage constraint
constraint gold_long * long_cables + gold_short * short_cables <= gold_available;

% At least 5 times as many short as long
constraint short_cables >= 5 * long_cables;

var int: total_profit = profit_long * long_cables + profit_short * short_cables;

solve maximize total_profit;

output [
  "Long cables = ", show(long_cables), "\n",
  "Short cables = ", show(short_cables), "\n",
  "Gold used = ", show(gold_long * long_cables + gold_short * short_cables), " mg\n",
  "Total profit = $", show(total_profit), "\n"
];