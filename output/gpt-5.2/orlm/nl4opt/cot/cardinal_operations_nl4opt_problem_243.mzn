% Parameters (with values embedded)
int: min_desk = 30;
int: min_night = 50;
int: max_desk = 150;
int: max_night = 180;
int: min_total = 100;

int: profit_desk = 5;
int: profit_night = 8;

% Variables
var 0..max_desk: desk_lamps;
var 0..max_night: night_lamps;
var 0..(profit_desk*max_desk + profit_night*max_night): total_profit;

% Constraints
constraint desk_lamps >= min_desk;
constraint night_lamps >= min_night;
constraint desk_lamps + night_lamps >= min_total;

constraint total_profit = profit_desk * desk_lamps + profit_night * night_lamps;

% Objective
solve maximize total_profit;