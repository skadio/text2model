% Parameters
int: TOTAL_ACRES = 1000;
int: rev_wheat = 2;
int: rev_corn = 3;
int: rev_barley = 1;

% Variables
var 0..TOTAL_ACRES: wheat;
var 0..TOTAL_ACRES: corn;
var 0..TOTAL_ACRES: barley;

var 0..(rev_wheat*TOTAL_ACRES + rev_corn*TOTAL_ACRES + rev_barley*TOTAL_ACRES): revenue;

% Constraints
constraint wheat + corn + barley <= TOTAL_ACRES;

% "twice the area planted with wheat plus the area planted with corn should be at least 500"
constraint 2*wheat + corn >= 500;

% "the area planted with wheat plus twice that of barley should not exceed 600"
constraint wheat + 2*barley <= 600;

constraint revenue = rev_wheat*wheat + rev_corn*corn + rev_barley*barley;

% Objective
solve minimize revenue;