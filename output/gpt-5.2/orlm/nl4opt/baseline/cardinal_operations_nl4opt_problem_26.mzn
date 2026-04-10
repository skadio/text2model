int: min_math = 40;
int: min_eng  = 60;
int: max_math = 140;
int: max_eng  = 170;
int: min_total = 200;

int: profit_math = 15;
int: profit_eng  = 17;

var min_math..max_math: math;
var min_eng..max_eng: eng;

constraint math + eng >= min_total;

var int: total_profit = profit_math * math + profit_eng * eng;

solve maximize total_profit;

output [
  "math=", show(math), "\n",
  "eng=", show(eng), "\n",
  "total=", show(math + eng), "\n",
  "profit=", show(total_profit), "\n"
];