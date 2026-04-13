% Parameters
int: max_wired = 100;
int: max_wireless = 170;
int: max_tested = 150;

int: profit_wired = 50;
int: profit_wireless = 20;

% Variables
var 0..max_wired: wired;
var 0..max_wireless: wireless;

% Constraints
constraint wired + wireless <= max_tested;

% Objective
solve maximize profit_wired * wired + profit_wireless * wireless;