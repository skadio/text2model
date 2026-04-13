% Parameters
int: total_acres = 50;
int: min_potatoes = 12;
int: min_cucumbers = 15;
int: profit_potatoes = 500;
int: profit_cucumbers = 650;

% Variables
var 0..total_acres: potatoes;
var 0..total_acres: cucumbers;
var 0..(profit_potatoes * total_acres + profit_cucumbers * total_acres): profit;

% Constraints
constraint potatoes + cucumbers <= total_acres;
constraint potatoes >= min_potatoes;
constraint cucumbers >= min_cucumbers;

% prefers more cucumbers than potatoes
constraint cucumbers >= potatoes + 1;

% at most twice the amount of cucumbers as potatoes
constraint cucumbers <= 2 * potatoes;

constraint profit = profit_potatoes * potatoes + profit_cucumbers * cucumbers;

% Objective
solve maximize profit;