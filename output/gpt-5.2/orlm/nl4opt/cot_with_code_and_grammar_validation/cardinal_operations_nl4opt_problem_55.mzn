% Parameters
int: total_acres = 300;
int: water_budget = 10000;
int: labor_days_available = 575;

int: labor_blueberries = 6;
int: labor_raspberries = 3;

int: water_blueberries = 22;
int: water_raspberries = 25;

int: profit_blueberries = 56;
int: profit_raspberries = 75;

% Variables
var 0..total_acres: acres_blueberries;
var 0..total_acres: acres_raspberries;

var 0..(profit_blueberries * total_acres + profit_raspberries * total_acres): total_profit;

% Constraints
constraint acres_blueberries + acres_raspberries <= total_acres;

constraint labor_blueberries * acres_blueberries + labor_raspberries * acres_raspberries
          <= labor_days_available;

constraint water_blueberries * acres_blueberries + water_raspberries * acres_raspberries
          <= water_budget;

constraint total_profit = profit_blueberries * acres_blueberries + profit_raspberries * acres_raspberries;

% Objective
solve maximize total_profit;