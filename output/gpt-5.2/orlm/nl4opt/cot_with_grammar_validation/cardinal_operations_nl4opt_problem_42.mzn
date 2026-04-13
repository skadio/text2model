% Parameters
float: t_coconut = 0.7;
float: t_lavender = 0.9;
int: min_coconut = 300;
int: max_total = 550;
int: max_coconut_factor = 3;

% Variables
var 0..max_total: coconut;
var 0..max_total: lavender;
var 0.0..(t_coconut*max_total + t_lavender*max_total): total_time;

% Constraints
constraint coconut >= min_coconut;
constraint coconut + lavender <= max_total;
constraint coconut <= max_coconut_factor * lavender;

constraint total_time = t_coconut * int2float(coconut) + t_lavender * int2float(lavender);

% Objective
solve minimize total_time;