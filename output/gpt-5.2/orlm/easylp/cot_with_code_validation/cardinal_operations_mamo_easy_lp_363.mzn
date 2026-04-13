% Parameters
int: cost_wheat = 2;
int: cost_corn = 3;
int: cost_soy = 1;
int: cost_pot = 4;

int: min_wheat_corn = 1000;
int: max_soy_pot = 800;
int: min_wheat_minus_soy = 200;
int: max_corn_pot = 500;

% Variables
var 0..2000: wheat;
var 0..2000: corn;
var 0..2000: soybeans;
var 0..2000: potatoes;

var 0..20000000: total_cost;

% Constraints
constraint wheat + corn >= min_wheat_corn;
constraint soybeans + potatoes <= max_soy_pot;
constraint wheat - soybeans >= min_wheat_minus_soy;
constraint corn + potatoes <= max_corn_pot;

constraint total_cost =
  cost_wheat * wheat +
  cost_corn * corn +
  cost_soy * soybeans +
  cost_pot * potatoes;

% Objective
solve minimize total_cost;