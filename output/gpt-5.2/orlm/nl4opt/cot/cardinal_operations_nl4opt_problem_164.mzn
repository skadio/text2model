% Parameters (with values embedded)
int: mover_available = 20000;
int: setup_available = 13000;

int: mover_per_refrigerator = 60;
int: setup_per_refrigerator = 20;

int: mover_per_stove = 45;
int: setup_per_stove = 25;

int: profit_refrigerator = 400;
int: profit_stove = 260;

% Variables
var 0..(mover_available div mover_per_refrigerator): refrigerators;
var 0..(mover_available div mover_per_stove): stoves;

% Constraints
constraint mover_per_refrigerator * refrigerators + mover_per_stove * stoves <= mover_available;
constraint setup_per_refrigerator * refrigerators + setup_per_stove * stoves <= setup_available;

% Objective
var int: total_profit = profit_refrigerator * refrigerators + profit_stove * stoves;
solve maximize total_profit;