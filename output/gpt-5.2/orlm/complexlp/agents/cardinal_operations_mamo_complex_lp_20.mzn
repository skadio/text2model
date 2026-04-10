% Parameters
% Number of foods
int: nFoods = 4;

% Index set of foods
set of int: FOODS = 1..nFoods;

% Cost per unit of each food (Chicken, Cheese, Rice, Beans)
array[FOODS] of int: cost = [5, 9, 2, 1];

% Nutrients per unit of each food
array[FOODS] of int: protein  = [16, 10, 12, 13];
array[FOODS] of int: carbs    = [22,  4, 21, 14];
array[FOODS] of int: calories = [292, 82, 207, 81];

% Minimum required nutrients
int: minProtein  = 94;
int: minCarbs    = 191;
int: minCalories = 2271;

% Variables
% Units of each food to consume (nonnegative integers)
array[FOODS] of var 0..1000: x;

% Total cost (nonnegative integer)
var 0..100000: totalCost;

% Constraints
% Link totalCost to chosen food quantities and unit costs
constraint
  totalCost = sum(f in FOODS)(cost[f] * x[f]);

% Meet minimum protein requirement
constraint
  sum(f in FOODS)(protein[f] * x[f]) >= minProtein;

% Meet minimum carbohydrate requirement
constraint
  sum(f in FOODS)(carbs[f] * x[f]) >= minCarbs;

% Meet minimum calorie requirement
constraint
  sum(f in FOODS)(calories[f] * x[f]) >= minCalories;

% Objective
solve minimize totalCost;