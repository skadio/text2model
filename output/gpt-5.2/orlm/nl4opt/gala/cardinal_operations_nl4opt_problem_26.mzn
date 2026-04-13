include "globals.mzn";

% Data (embedded from problem statement)
int: min_math = 40;
int: min_eng  = 60;
int: max_math = 140;
int: max_eng  = 170;
int: min_total = 200;

int: profit_math = 15;
int: profit_eng  = 17;

% Decision variables
var min_math..max_math: math;
var min_eng..max_eng: eng;

% Constraints
constraint math + eng >= min_total;

% Objective: maximize profit
var int: total_profit = profit_math * math + profit_eng * eng;

solve maximize total_profit;

output [
  "Math workbooks = ", show(math), "\n",
  "English workbooks = ", show(eng), "\n",
  "Total workbooks = ", show(math + eng), "\n",
  "Total profit = $", show(total_profit), "\n"
];