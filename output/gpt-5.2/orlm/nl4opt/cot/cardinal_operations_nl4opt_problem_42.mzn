% Parameters (with values embedded)
float: time_coconut = 0.7;
float: time_lavender = 0.9;
int: min_coconut = 300;
int: max_total = 550;

% Variables
var 0..max_total: coconut;
var 0..max_total: lavender;

% Constraints
constraint coconut >= min_coconut;
constraint coconut + lavender <= max_total;
constraint coconut <= 3 * lavender;

% Objective
solve minimize time_coconut * coconut + time_lavender * lavender;