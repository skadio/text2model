% Parameters
int: min_math = 40;
int: min_english = 60;
int: max_math = 140;
int: max_english = 170;
int: min_total = 200;
int: profit_math = 15;
int: profit_english = 17;

% Variables
var min_math..max_math: math;
var min_english..max_english: english;
var int: total_profit;

% Constraints
constraint math + english >= min_total;

constraint total_profit = profit_math * math + profit_english * english;

% Objective
solve maximize total_profit;