% Parameters
float: t_coconut = 0.7;
float: t_lavender = 0.9;
int: min_coconut = 300;
int: max_total = 550;
int: coconut_to_lavender_ratio = 3;

% Variables
var 0..max_total: coconut;
var 0..max_total: lavender;

% Constraints
constraint coconut >= min_coconut;
constraint coconut + lavender <= max_total;
constraint coconut <= coconut_to_lavender_ratio * lavender;

% Objective
solve minimize t_coconut * coconut + t_lavender * lavender;