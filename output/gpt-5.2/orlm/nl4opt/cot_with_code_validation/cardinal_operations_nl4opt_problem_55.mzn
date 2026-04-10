% Parameters
int: total_acres = 300;
int: total_labor_days = 575;
int: total_water_budget = 10000;

int: labor_blueberries = 6;
int: labor_raspberries = 3;

int: water_blueberries = 22;
int: water_raspberries = 25;

int: profit_blueberries = 56;
int: profit_raspberries = 75;

% Variables
var 0..total_acres: acres_blueberries;
var 0..total_acres: acres_raspberries;

% Constraints
constraint acres_blueberries + acres_raspberries <= total_acres;

constraint labor_blueberries * acres_blueberries
         + labor_raspberries * acres_raspberries <= total_labor_days;

constraint water_blueberries * acres_blueberries
         + water_raspberries * acres_raspberries <= total_water_budget;

% Objective
solve maximize profit_blueberries * acres_blueberries
             + profit_raspberries * acres_raspberries;