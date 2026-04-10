% Parameters (with values embedded)
int: kids_capacity = 100;      % ml per kids bottle
int: adult_capacity = 300;     % ml per adult bottle
int: total_syrup = 25000;      % ml available
int: min_kids = 50;            % at least 50 kids bottles
int: adult_to_kids_ratio = 3;  % adult bottles >= 3 * kids bottles

% Variables
var 0..(total_syrup div kids_capacity): kids_bottles;
var 0..(total_syrup div adult_capacity): adult_bottles;

% Constraints
constraint kids_bottles >= min_kids;
constraint adult_bottles >= adult_to_kids_ratio * kids_bottles;
constraint kids_capacity * kids_bottles + adult_capacity * adult_bottles <= total_syrup;

% Objective
solve maximize kids_bottles + adult_bottles;