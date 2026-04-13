% Parameters
int: kids_capacity = 100;
int: adult_capacity = 300;
int: total_syrup = 25000;

int: min_kids = 50;
int: adult_to_kids_ratio = 3;

% Variables
var 0..(total_syrup div kids_capacity): kids_bottles;
var 0..(total_syrup div adult_capacity): adult_bottles;

var 0..(total_syrup div kids_capacity + total_syrup div adult_capacity): total_bottles;

% Constraints
constraint kids_bottles >= min_kids;

constraint adult_bottles >= adult_to_kids_ratio * kids_bottles;

constraint kids_capacity * kids_bottles + adult_capacity * adult_bottles <= total_syrup;

constraint total_bottles = kids_bottles + adult_bottles;

% Objective
solve maximize total_bottles;