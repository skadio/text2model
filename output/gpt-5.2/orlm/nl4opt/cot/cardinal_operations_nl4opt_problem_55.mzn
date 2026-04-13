% Parameters (with values embedded)
int: total_acres = 300;
int: total_budget = 10000;     % dollars for watering
int: total_labor = 575;        % labor-days available

int: labor_blueberries = 6;    % labor-days per acre
int: labor_raspberries = 3;

int: water_blueberries = 22;   % dollars per acre
int: water_raspberries = 25;

int: profit_blueberries = 56;  % profit per acre
int: profit_raspberries = 75;

% Variables
var 0..total_acres: acres_blueberries;
var 0..total_acres: acres_raspberries;

% Constraints
constraint acres_blueberries + acres_raspberries <= total_acres;

constraint labor_blueberries * acres_blueberries
         + labor_raspberries * acres_raspberries <= total_labor;

constraint water_blueberries * acres_blueberries
         + water_raspberries * acres_raspberries <= total_budget;

% Objective
solve maximize profit_blueberries * acres_blueberries
             + profit_raspberries * acres_raspberries;