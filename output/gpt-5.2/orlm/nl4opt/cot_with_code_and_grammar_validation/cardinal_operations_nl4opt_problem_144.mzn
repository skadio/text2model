% Parameters
int: vit_veg = 2;
int: min_veg = 3;
int: vit_fruit = 4;
int: min_fruit = 1;

int: req_vit = 20;
int: req_min = 30;

int: cost_veg = 3;
int: cost_fruit = 5;

int: max_veg = req_min div min_veg + 20;
int: max_fruit = req_vit div vit_fruit + 20;

% Variables
var 0..max_veg: veg_servings;
var 0..max_fruit: fruit_servings;

var 0..(cost_veg*max_veg + cost_fruit*max_fruit): total_cost;

% Constraints
constraint vit_veg * veg_servings + vit_fruit * fruit_servings >= req_vit;
constraint min_veg * veg_servings + min_fruit * fruit_servings >= req_min;

constraint total_cost = cost_veg * veg_servings + cost_fruit * fruit_servings;

% Objective
solve minimize total_cost;