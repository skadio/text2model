% Parameters
int: cost_wheat = 2;
int: cost_corn = 3;
int: cost_soy = 1;
int: cost_potato = 4;

int: min_wheat_corn = 1000;
int: max_soy_potato = 800;
int: min_wheat_minus_soy = 200;
int: max_corn_potato = 500;

% Variables
var 0..2000: wheat;
var 0..2000: corn;
var 0..2000: soy;
var 0..2000: potato;

var 0..200000: total_cost;

% Constraints
constraint wheat + corn >= min_wheat_corn;
constraint soy + potato <= max_soy_potato;
constraint wheat - soy >= min_wheat_minus_soy;
constraint corn + potato <= max_corn_potato;

constraint total_cost =
  cost_wheat * wheat +
  cost_corn * corn +
  cost_soy * soy +
  cost_potato * potato;

% Objective
solve minimize total_cost;