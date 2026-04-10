% Parameters
int: n_foods = 9;

set of int: FOODS = 1..n_foods;

array[FOODS] of string: food_name =
  ["Beef","Pasta","Broccoli","Chicken","Apple","Pork","Lentils","Eggs","Cheese"];

array[FOODS] of int: cost =
  [5, 6, 5, 4, 1, 6, 1, 2, 7]; % dollars per serving/unit

array[FOODS] of int: protein =
  [18, 2, 7, 20, 5, 13, 15, 20, 9]; % grams per serving/unit

array[FOODS] of int: carbs =
  [13, 25, 30, 16, 6, 9, 18, 18, 14]; % grams per serving/unit

array[FOODS] of int: calories =
  [233, 251, 191, 231, 111, 275, 99, 210, 74]; % calories per serving/unit

int: min_protein = 68;    % grams/day
int: min_carbs = 151;     % grams/day
int: min_calories = 1900; % calories/day


% Variables
array[FOODS] of var 0..1000: servings; % number of servings/units of each food (non-negative integer)

var 0..100000: total_cost;     % total cost (dollars)
var 0..100000: total_protein;  % total protein (grams)
var 0..100000: total_carbs;    % total carbohydrates (grams)
var 0..100000: total_calories; % total calories


% Constraints
% Link total aggregates to chosen servings (linear definitions)
constraint
  total_cost = sum(f in FOODS)(cost[f] * servings[f]);

constraint
  total_protein = sum(f in FOODS)(protein[f] * servings[f]);

constraint
  total_carbs = sum(f in FOODS)(carbs[f] * servings[f]);

constraint
  total_calories = sum(f in FOODS)(calories[f] * servings[f]);

% Meet minimum daily nutritional requirements
constraint total_protein >= min_protein;
constraint total_carbs >= min_carbs;
constraint total_calories >= min_calories;


% Objective
solve minimize total_cost;