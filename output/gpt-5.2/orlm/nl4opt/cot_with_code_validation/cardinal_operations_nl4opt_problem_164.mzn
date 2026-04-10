% Parameters
int: mover_time_fridge = 60;
int: setup_time_fridge = 20;
int: mover_time_stove = 45;
int: setup_time_stove = 25;

int: mover_time_available = 20000;
int: setup_time_available = 13000;

int: profit_fridge = 400;
int: profit_stove = 260;

% Variables
var 0..mover_time_available div mover_time_fridge: x_fridge;
var 0..mover_time_available div mover_time_stove: x_stove;
var 0..(profit_fridge * (mover_time_available div mover_time_fridge) + profit_stove * (mover_time_available div mover_time_stove)): total_profit;

% Constraints
constraint mover_time_fridge * x_fridge + mover_time_stove * x_stove <= mover_time_available;
constraint setup_time_fridge * x_fridge + setup_time_stove * x_stove <= setup_time_available;

constraint total_profit = profit_fridge * x_fridge + profit_stove * x_stove;

% Objective
solve maximize total_profit;