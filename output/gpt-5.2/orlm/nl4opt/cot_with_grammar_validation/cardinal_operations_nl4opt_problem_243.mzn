% Parameters
int: min_desk = 30;
int: min_night = 50;
int: max_desk = 150;
int: max_night = 180;
int: min_total = 100;

int: profit_desk = 5;
int: profit_night = 8;

% Variables
var min_desk..max_desk: desk;
var min_night..max_night: night;

var 0..(max_desk + max_night): total;
var 0..(profit_desk * max_desk + profit_night * max_night): profit;

% Constraints
constraint total = desk + night;
constraint total >= min_total;

constraint profit = profit_desk * desk + profit_night * night;

% Objective
solve maximize profit;