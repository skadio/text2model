% Parameters
int: vit_per_veg = 2;          % vitamins per serving of vegetables
int: min_per_veg = 3;          % minerals per serving of vegetables
int: vit_per_fruit = 4;        % vitamins per serving of fruit
int: min_per_fruit = 1;        % minerals per serving of fruit

int: req_vitamins = 20;        % minimum required vitamins
int: req_minerals = 30;        % minimum required minerals

int: cost_veg = 3;             % cost per serving of vegetables
int: cost_fruit = 5;           % cost per serving of fruit

% Variables
% Upper bounds derived from satisfying vitamin requirement using only one food type.
var 0..ceil(int2float(req_vitamins) / int2float(vit_per_veg)): veg_servings;
var 0..ceil(int2float(req_vitamins) / int2float(vit_per_fruit)): fruit_servings;

% Total cost (bounded using the above maximal servings)
var 0..(cost_veg * ceil(int2float(req_vitamins) / int2float(vit_per_veg))
      + cost_fruit * ceil(int2float(req_vitamins) / int2float(vit_per_fruit))): total_cost;

% Constraints
% Link total_cost to the number of servings chosen
constraint
  total_cost = cost_veg * veg_servings + cost_fruit * fruit_servings;

% Meet minimum vitamin requirement
constraint
  vit_per_veg * veg_servings + vit_per_fruit * fruit_servings >= req_vitamins;

% Meet minimum mineral requirement
constraint
  min_per_veg * veg_servings + min_per_fruit * fruit_servings >= req_minerals;

% Objective
solve minimize total_cost;