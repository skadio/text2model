% Parameters
int: mover_time_per_refrigerator = 60;
int: setup_time_per_refrigerator = 20;
int: mover_time_per_stove = 45;
int: setup_time_per_stove = 25;

int: mover_time_available = 20000;
int: setup_time_available = 13000;

int: profit_per_refrigerator = 400;
int: profit_per_stove = 260;

% Variables
var 0..(mover_time_available div mover_time_per_refrigerator): refrigerators;
var 0..(mover_time_available div mover_time_per_stove): stoves;

% Constraints
constraint
  mover_time_per_refrigerator * refrigerators + mover_time_per_stove * stoves <= mover_time_available;

constraint
  setup_time_per_refrigerator * refrigerators + setup_time_per_stove * stoves <= setup_time_available;

% Objective
solve maximize profit_per_refrigerator * refrigerators + profit_per_stove * stoves;