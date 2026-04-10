% Parameters
int: max_wired = 100;
int: max_wireless = 170;
int: max_machine = 150;

int: profit_wired = 50;
int: profit_wireless = 20;

% Variables
var 0..max_wired: wired;
var 0..max_wireless: wireless;

var 0..(profit_wired*max_wired + profit_wireless*max_wireless): total_profit;

% Constraints
constraint wired + wireless <= max_machine;

constraint total_profit = profit_wired * wired + profit_wireless * wireless;

% Objective
solve maximize total_profit;