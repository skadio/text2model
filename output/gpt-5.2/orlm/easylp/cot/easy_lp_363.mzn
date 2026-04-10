% Parameters (with values embedded)
int: cost_wheat = 2;
int: cost_corn = 3;
int: cost_soybeans = 1;
int: cost_potatoes = 4;

int: min_wheat_plus_corn = 1000;
int: max_soybeans_plus_potatoes = 800;
int: min_wheat_minus_soybeans = 200;
int: max_corn_plus_potatoes = 500;

% Variables
var 0..100000: Wheat;
var 0..100000: Corn;
var 0..100000: Soybeans;
var 0..100000: Potatoes;

var 0..1000000000: TotalCost;

% Constraints
constraint Wheat + Corn >= min_wheat_plus_corn;
constraint Soybeans + Potatoes <= max_soybeans_plus_potatoes;
constraint Wheat - Soybeans >= min_wheat_minus_soybeans;
constraint Corn + Potatoes <= max_corn_plus_potatoes;

constraint TotalCost = cost_wheat * Wheat
                     + cost_corn * Corn
                     + cost_soybeans * Soybeans
                     + cost_potatoes * Potatoes;

% Objective
solve minimize TotalCost;