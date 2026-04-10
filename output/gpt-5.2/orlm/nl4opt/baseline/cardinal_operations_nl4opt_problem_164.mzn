int: mover_avail = 20000;
int: setup_avail = 13000;

int: mover_per_fridge = 60;
int: setup_per_fridge = 20;
int: profit_fridge = 400;

int: mover_per_stove = 45;
int: setup_per_stove = 25;
int: profit_stove = 260;

var 0..mover_avail div mover_per_fridge: refrigerators;
var 0..mover_avail div mover_per_stove: stoves;

constraint mover_per_fridge * refrigerators + mover_per_stove * stoves <= mover_avail;
constraint setup_per_fridge * refrigerators + setup_per_stove * stoves <= setup_avail;

var int: total_profit = profit_fridge * refrigerators + profit_stove * stoves;

solve maximize total_profit;

output [
  "refrigerators=", show(refrigerators), "\n",
  "stoves=", show(stoves), "\n",
  "total_profit=", show(total_profit), "\n"
];