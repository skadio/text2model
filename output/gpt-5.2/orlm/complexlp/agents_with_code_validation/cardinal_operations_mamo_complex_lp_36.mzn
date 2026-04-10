% Parameters
int: nFoods = 4;                                  % Number of food items
set of int: FOODS = 1..nFoods;                    % Index set for foods

% Food names (for readability/debugging)
array[FOODS] of string: foodName =
  ["Steak", "Eggs", "Pasta", "Chicken"];

% Cost per unit of each food
array[FOODS] of int: cost =
  [4, 1, 9, 4];

% Nutrients per unit of each food
array[FOODS] of int: protein =
  [20, 7, 1, 10];

array[FOODS] of int: carbs =
  [2, 3, 26, 1];

array[FOODS] of int: calories =
  [68, 143, 52, 69];

% Minimum required nutrients
int: minProtein = 71;
int: minCarbs = 141;
int: minCalories = 1839;


% Variables
array[FOODS] of var 0..1000: qty;                 % Units of each food to buy/consume
var 0..100000: totalCost;                         % Total cost (objective)

% Nutrient totals (helpful derived variables)
var 0..100000: totalProtein;
var 0..100000: totalCarbs;
var 0..100000: totalCalories;


% Constraints

% Link total cost to chosen quantities
constraint
  totalCost = sum(f in FOODS)(cost[f] * qty[f]);

% Compute total nutrients from chosen quantities
constraint
  totalProtein = sum(f in FOODS)(protein[f] * qty[f]);

constraint
  totalCarbs = sum(f in FOODS)(carbs[f] * qty[f]);

constraint
  totalCalories = sum(f in FOODS)(calories[f] * qty[f]);

% Enforce minimum nutrient requirements
constraint
  totalProtein >= minProtein;

constraint
  totalCarbs >= minCarbs;

constraint
  totalCalories >= minCalories;


% Objective
solve minimize totalCost;

% Output only the optimal cost value (as requested)
output [ show(totalCost) ];