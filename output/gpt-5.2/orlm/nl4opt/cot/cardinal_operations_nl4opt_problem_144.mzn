% Parameters (with values embedded)
int: vit_veg = 2;
int: min_veg = 3;
int: vit_fruit = 4;
int: min_fruit = 1;

int: req_vit = 20;
int: req_min = 30;

int: cost_veg = 3;
int: cost_fruit = 5;

% Variables
var 0..100: veg_servings;
var 0..100: fruit_servings;
var 0..1000: total_cost;

% Constraints
constraint vit_veg * veg_servings + vit_fruit * fruit_servings >= req_vit;
constraint min_veg * veg_servings + min_fruit * fruit_servings >= req_min;

constraint total_cost = cost_veg * veg_servings + cost_fruit * fruit_servings;

% Objective
solve minimize total_cost;