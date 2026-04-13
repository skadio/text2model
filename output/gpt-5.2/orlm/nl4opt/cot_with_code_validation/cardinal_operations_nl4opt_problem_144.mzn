% Parameters
int: veg_vitamins = 2;
int: veg_minerals = 3;
int: fruit_vitamins = 4;
int: fruit_minerals = 1;

int: min_vitamins = 20;
int: min_minerals = 30;

int: cost_veg = 3;
int: cost_fruit = 5;

% Variables
var 0..30: veg_servings;
var 0..30: fruit_servings;

% Constraints
constraint veg_vitamins * veg_servings + fruit_vitamins * fruit_servings >= min_vitamins;
constraint veg_minerals * veg_servings + fruit_minerals * fruit_servings >= min_minerals;

% Objective
solve minimize cost_veg * veg_servings + cost_fruit * fruit_servings;