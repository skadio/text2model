% Parameters
int: veg_vitamins = 2;          % vitamins per serving of vegetables
int: veg_minerals = 3;          % minerals per serving of vegetables
int: fruit_vitamins = 4;        % vitamins per serving of fruit
int: fruit_minerals = 1;        % minerals per serving of fruit

int: min_vitamins = 20;         % required minimum vitamins
int: min_minerals = 30;         % required minimum minerals

int: cost_veg = 3;              % cost per serving of vegetables
int: cost_fruit = 5;            % cost per serving of fruit

% Variables
% Upper bounds chosen conservatively to ensure feasibility within the domain.
int: ub_veg = max( (min_vitamins + veg_vitamins - 1) div veg_vitamins,
                   (min_minerals + veg_minerals - 1) div veg_minerals) * 2;
int: ub_fruit = max( (min_vitamins + fruit_vitamins - 1) div fruit_vitamins,
                     (min_minerals + fruit_minerals - 1) div fruit_minerals) * 2;

var 0..ub_veg: veg_servings;
var 0..ub_fruit: fruit_servings;

var 0..(cost_veg * ub_veg + cost_fruit * ub_fruit): total_cost;

% Constraints
% Nutrition requirements: ensure minimum vitamins intake
constraint
  veg_vitamins * veg_servings + fruit_vitamins * fruit_servings >= min_vitamins;

% Nutrition requirements: ensure minimum minerals intake
constraint
  veg_minerals * veg_servings + fruit_minerals * fruit_servings >= min_minerals;

% Cost definition: link total_cost to the chosen servings
constraint
  total_cost = cost_veg * veg_servings + cost_fruit * fruit_servings;

% Objective
solve minimize total_cost;