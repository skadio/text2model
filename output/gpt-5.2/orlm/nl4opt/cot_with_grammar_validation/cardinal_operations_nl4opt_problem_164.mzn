% Parameters
int: mover_time_per_refrigerator = 60;
int: setup_time_per_refrigerator = 20;
int: mover_time_per_stove = 45;
int: setup_time_per_stove = 25;

int: total_mover_time = 20000;
int: total_setup_time = 13000;

int: profit_per_refrigerator = 400;
int: profit_per_stove = 260;

% Variables
var 0..(total_mover_time div mover_time_per_refrigerator): refrigerators;
var 0..(total_mover_time div mover_time_per_stove): stoves;

% Constraints
constraint
  mover_time_per_refrigerator * refrigerators + mover_time_per_stove * stoves <= total_mover_time;

constraint
  setup_time_per_refrigerator * refrigerators + setup_time_per_stove * stoves <= total_setup_time;

% Objective
solve maximize profit_per_refrigerator * refrigerators + profit_per_stove * stoves;