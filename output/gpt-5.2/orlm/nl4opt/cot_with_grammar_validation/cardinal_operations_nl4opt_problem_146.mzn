% Parameters
int: dough_large = 12;
int: topping_large = 5;
int: bake_large = 12;

int: dough_medium = 8;
int: topping_medium = 4;
int: bake_medium = 8;

int: min_dough = 10000;
int: min_toppings = 4400;

int: min_medium = 200;

% Variables
var 0..max(min_dough div dough_large, min_toppings div topping_large): L; % large pizzas
var min_medium..max(min_dough div dough_medium, min_toppings div topping_medium): M; % medium pizzas

var 0..(bake_large * (min_dough div dough_large) + bake_medium * (min_dough div dough_medium)): total_bake_time;

% Constraints
constraint dough_large * L + dough_medium * M >= min_dough;
constraint topping_large * L + topping_medium * M >= min_toppings;

constraint M >= min_medium;
constraint L >= 2 * M;

constraint total_bake_time = bake_large * L + bake_medium * M;

% Objective
solve minimize total_bake_time;