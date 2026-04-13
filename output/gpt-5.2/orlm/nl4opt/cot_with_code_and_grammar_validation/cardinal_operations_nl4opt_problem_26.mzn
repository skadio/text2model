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

% Constraints
constraint math + english >= min_total;

% Objective
solve maximize profit_math * math + profit_english * english;