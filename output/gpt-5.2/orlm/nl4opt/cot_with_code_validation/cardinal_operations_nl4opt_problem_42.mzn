% Parameters
int: min_coconut = 300;
int: max_total = 550;
float: time_coconut = 0.7;
float: time_lavender = 0.9;

% Variables
var 0..max_total: coconut;
var 0..max_total: lavender;
var float: total_time;

% Constraints
constraint coconut >= min_coconut;
constraint coconut + lavender <= max_total;
constraint coconut <= 3 * lavender;

constraint total_time = time_coconut * coconut + time_lavender * lavender;

% Objective
solve minimize total_time;