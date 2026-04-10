% Parameters
int: n_foods = 6;                                  % number of available food items
set of int: FOODS = 1..n_foods;                    % index set for foods

array[FOODS] of int: cost = [4, 2, 6, 2, 6, 8];       % cost per unit of each food item
array[FOODS] of int: protein = [17, 4, 7, 14, 13, 1]; % protein grams per unit
array[FOODS] of int: carbs = [8, 24, 27, 16, 1, 13];  % carbohydrate grams per unit
array[FOODS] of int: calories = [237, 213, 133, 118, 136, 225]; % calories per unit

int: min_protein = 76;                             % minimum required protein grams
int: min_carbs = 173;                              % minimum required carbohydrate grams
int: min_calories = 1751;                          % minimum required calories

% Variables
array[FOODS] of var 0..10000: qty;                 % units chosen of each food item (non-negative integer)
var 0..1000000: total_cost;                        % total cost of the chosen meal plan

% Constraints
% Link total_cost to chosen quantities and per-item costs
constraint
  total_cost = sum(f in FOODS)(cost[f] * qty[f]);

% Meet minimum protein requirement
constraint
  sum(f in FOODS)(protein[f] * qty[f]) >= min_protein;

% Meet minimum carbohydrate requirement
constraint
  sum(f in FOODS)(carbs[f] * qty[f]) >= min_carbs;

% Meet minimum calories requirement
constraint
  sum(f in FOODS)(calories[f] * qty[f]) >= min_calories;

% Objective
solve minimize total_cost;