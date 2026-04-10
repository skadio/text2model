% Parameters
int: kids_volume = 100;
int: adult_volume = 300;
int: total_volume = 25000;
int: min_kids = 50;
int: adult_to_kids_ratio = 3;

% Variables
var 0..(total_volume div kids_volume): kids_bottles;
var 0..(total_volume div adult_volume): adult_bottles;

% Constraints
constraint kids_bottles >= min_kids;
constraint adult_bottles >= adult_to_kids_ratio * kids_bottles;
constraint kids_volume * kids_bottles + adult_volume * adult_bottles <= total_volume;

% Objective
solve maximize kids_bottles + adult_bottles;