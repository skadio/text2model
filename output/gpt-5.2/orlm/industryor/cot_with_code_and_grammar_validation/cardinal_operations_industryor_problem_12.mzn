% Parameters
int: total_acres = 100;

int: profit_corn = 1500;
int: profit_wheat = 1200;
int: profit_soy = 1800;
int: profit_sorghum = 1600;

% Variables
var 0..total_acres: corn;
var 0..total_acres: wheat;
var 0..total_acres: soybeans;
var 0..total_acres: sorghum;

var int: total_profit;

% Constraints
constraint corn + wheat + soybeans + sorghum <= total_acres;

constraint corn >= 2 * wheat;
constraint soybeans >= sorghum div 2;
constraint wheat = 3 * sorghum;

constraint total_profit =
  profit_corn * corn +
  profit_wheat * wheat +
  profit_soy * soybeans +
  profit_sorghum * sorghum;

% Objective
solve maximize total_profit;