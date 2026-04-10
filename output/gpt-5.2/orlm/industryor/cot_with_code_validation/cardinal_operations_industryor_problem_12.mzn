% Parameters
int: total_acres = 100;

int: profit_corn = 1500;
int: profit_wheat = 1200;
int: profit_soy = 1800;
int: profit_sorghum = 1600;

% Variables
var 0..total_acres: acres_corn;
var 0..total_acres: acres_wheat;
var 0..total_acres: acres_soy;
var 0..total_acres: acres_sorghum;

var 0..(max([profit_corn, profit_wheat, profit_soy, profit_sorghum]) * total_acres): total_profit;

% Constraints
constraint acres_corn + acres_wheat + acres_soy + acres_sorghum = total_acres;

constraint acres_corn >= 2 * acres_wheat;

constraint acres_soy * 2 >= acres_sorghum;

constraint acres_wheat = 3 * acres_sorghum;

constraint total_profit =
  profit_corn * acres_corn +
  profit_wheat * acres_wheat +
  profit_soy * acres_soy +
  profit_sorghum * acres_sorghum;

% Objective
solve maximize total_profit;