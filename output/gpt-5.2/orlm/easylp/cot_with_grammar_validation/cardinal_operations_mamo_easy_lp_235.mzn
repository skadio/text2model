% Parameters
int: total_acres = 1000;
int: rev_wheat = 2;
int: rev_corn  = 3;
int: rev_barley = 1;

% Constraints encoded as linear inequalities:
% 2*wheat + corn >= 500
int: min_wheat_corn_expr = 500;

% wheat + 2*barley <= 600
int: max_wheat_barley_expr = 600;

% Variables
var 0..total_acres: wheat;
var 0..total_acres: corn;
var 0..total_acres: barley;

var 0..(rev_wheat*total_acres + rev_corn*total_acres + rev_barley*total_acres): revenue;

% Constraints
constraint wheat + corn + barley <= total_acres;

constraint 2*wheat + corn >= min_wheat_corn_expr;

constraint wheat + 2*barley <= max_wheat_barley_expr;

constraint revenue = rev_wheat*wheat + rev_corn*corn + rev_barley*barley;

% Objective
solve minimize revenue;