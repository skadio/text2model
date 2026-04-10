% Parameters
int: min_choc = 5;
int: min_van = 5;
int: max_choc = 10;
int: max_van = 8;

int: hours_per_choc = 1;
int: hours_per_van = 2;
int: hours_available = 30;

int: min_workers = 6;
int: workers_per_choc = 1;
int: workers_per_van = 2;

int: profit_choc = 200;
int: profit_van = 300;

% Variables
var min_choc..max_choc: choc_gallons;
var min_van..max_van: van_gallons;

var 0..(profit_choc*max_choc + profit_van*max_van): total_profit;

% Constraints
constraint hours_per_choc * choc_gallons + hours_per_van * van_gallons <= hours_available;

constraint workers_per_choc * choc_gallons + workers_per_van * van_gallons >= min_workers;

constraint total_profit = profit_choc * choc_gallons + profit_van * van_gallons;

% Objective
solve maximize total_profit;