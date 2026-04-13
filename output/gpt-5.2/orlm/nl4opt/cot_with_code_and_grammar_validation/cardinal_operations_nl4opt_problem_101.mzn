% Parameters
int: water_sub = 10;
int: water_top = 6;
int: capacity_total = 150;
int: min_top = 10;
int: top_percent_num = 30;
int: top_percent_den = 100;

% Variables
var 0..capacity_total: sub;
var 0..capacity_total: top;

% Constraints
constraint sub + top <= capacity_total;
constraint top >= min_top;
constraint top_percent_den * top <= top_percent_num * (sub + top);

% Objective
solve minimize water_sub * sub + water_top * top;