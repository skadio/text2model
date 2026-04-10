% Parameters
int: nFoods = 6; % number of food items
set of int: FOODS = 1..nFoods; % index set for foods

array[FOODS] of string: foodName =
  ["Eggs","Chicken","Tofu","Salmon","Brown Rice","Spinach"]; % names (for readability)

array[FOODS] of int: cost =
  [10, 9, 2, 10, 8, 1]; % cost per unit of each food item

array[FOODS] of int: protein =
  [1, 4, 13, 8, 7, 8]; % grams of protein per unit

array[FOODS] of int: carbs =
  [13, 10, 9, 3, 13, 16]; % grams of carbohydrates per unit

array[FOODS] of int: calories =
  [211, 256, 273, 54, 93, 52]; % calories per unit

int: minProtein  = 60;   % minimum daily protein requirement
int: minCarbs    = 122;  % minimum daily carbohydrate requirement
int: minCalories = 2028; % minimum daily calorie requirement


% Variables
array[FOODS] of var 0..10000: qty; % number of units of each food item (nonnegative integer)

var 0..1000000: totalCost; % total daily cost

% Supporting totals (useful for constraints/debugging)
var 0..1000000: totalProtein;
var 0..1000000: totalCarbs;
var 0..100000000: totalCalories;


% Constraints
% --- Define total nutrient and cost aggregates ---
constraint totalCost = sum(f in FOODS)(cost[f] * qty[f]);
constraint totalProtein = sum(f in FOODS)(protein[f] * qty[f]);
constraint totalCarbs = sum(f in FOODS)(carbs[f] * qty[f]);
constraint totalCalories = sum(f in FOODS)(calories[f] * qty[f]);

% --- Meet minimum daily nutritional requirements ---
constraint totalProtein  >= minProtein;
constraint totalCarbs    >= minCarbs;
constraint totalCalories >= minCalories;


% Objective
solve minimize totalCost;