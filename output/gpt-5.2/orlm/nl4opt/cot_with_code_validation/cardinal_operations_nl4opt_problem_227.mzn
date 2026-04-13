% Parameters
int: reg_hours = 10;
int: reg_cost  = 300;
int: emg_hours = 6;
int: emg_cost  = 100;

int: min_total_hours = 300;
int: budget = 7000;

% Variables
var 0..(budget div reg_cost): reg;
var 0..(budget div emg_cost): emg;

% Constraints
constraint reg_hours * reg + emg_hours * emg >= min_total_hours;
constraint reg_cost  * reg + emg_cost  * emg <= budget;

% Objective
solve minimize reg + emg;