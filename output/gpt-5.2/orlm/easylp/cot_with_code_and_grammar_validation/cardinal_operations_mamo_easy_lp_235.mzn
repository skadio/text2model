% Parameters
int: total_land = 1000;
int: rev_wheat = 2;
int: rev_corn = 3;
int: rev_barley = 1;

% Variables
var 0..total_land: wheat;
var 0..total_land: corn;
var 0..total_land: barley;

var 0..(rev_wheat*total_land + rev_corn*total_land + rev_barley*total_land): revenue;

% Constraints
constraint wheat + corn + barley <= total_land;

% Twice wheat plus corn at least 500
constraint 2*wheat + corn >= 500;

% Wheat plus twice barley at most 600
constraint wheat + 2*barley <= 600;

constraint revenue = rev_wheat*wheat + rev_corn*corn + rev_barley*barley;

% Objective
solve minimize revenue;