% Parameters
int: total_budget = 600000;
int: apt_max = 200000;
float: apt_return = 0.10;
float: town_return = 0.15;

% Variables
var 0..total_budget: apt;
var 0..total_budget: town;
var float: profit;

% Constraints
constraint apt + town = total_budget;
constraint apt <= apt_max;
constraint apt >= town / 2;

constraint profit = apt_return * int2float(apt) + town_return * int2float(town);

% Objective
solve maximize profit;