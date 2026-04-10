% Parameters
int: total_acres = 300;
int: budget = 10000;
int: labor_days = 575;

int: labor_blue = 6;
int: labor_rasp = 3;

int: water_blue = 22;
int: water_rasp = 25;

int: profit_blue = 56;
int: profit_rasp = 75;

% Variables
var 0..total_acres: x_blue; % acres of blueberries
var 0..total_acres: x_rasp; % acres of raspberries

% Constraints
constraint x_blue + x_rasp <= total_acres;

constraint labor_blue * x_blue + labor_rasp * x_rasp <= labor_days;

constraint water_blue * x_blue + water_rasp * x_rasp <= budget;

% Objective
solve maximize profit_blue * x_blue + profit_rasp * x_rasp;