% Parameters
int: n_foods = 6;                              % number of food items
set of int: FOODS = 1..n_foods;                % index set for foods

array[FOODS] of string: food_name =            % names of foods (for readability/output)
  ["Chicken Breast", "Brown Rice", "Tofu", "Spinach", "Almonds", "Salmon"];

array[FOODS] of int: cost =                    % cost per serving ($)
  [4, 10, 6, 1, 8, 6];

array[FOODS] of int: protein =                 % grams of protein per serving
  [14, 11, 20, 6, 9, 20];

array[FOODS] of int: carbs =                   % grams of carbohydrates per serving
  [4, 17, 12, 20, 11, 19];

array[FOODS] of int: calories =                % calories per serving
  [275, 151, 155, 106, 279, 93];

int: req_protein = 78;                         % required daily protein (g)
int: req_carbs = 140;                          % required daily carbs (g)
int: req_calories = 1537;                      % required daily calories

% Variables
array[FOODS] of var 0..100: servings;          % servings of each food (nonnegative integer, bounded)
var 0..100000: total_cost;                     % total cost ($), bounded for safety

% Constraints
% Link total_cost to chosen servings and per-serving costs
constraint
  total_cost = sum(f in FOODS)(cost[f] * servings[f]);

% Meet or exceed required daily protein intake
constraint
  sum(f in FOODS)(protein[f] * servings[f]) >= req_protein;

% Meet or exceed required daily carbohydrate intake
constraint
  sum(f in FOODS)(carbs[f] * servings[f]) >= req_carbs;

% Meet or exceed required daily calorie intake
constraint
  sum(f in FOODS)(calories[f] * servings[f]) >= req_calories;

% Objective
solve minimize total_cost;