% Parameters
% Number of food items
int: nFoods = 4;
set of int: FOODS = 1..nFoods;

% Food item names (for readable output)
array[FOODS] of string: foodName = ["Chicken", "Tofu", "Rice", "Avocado"];

% Cost per unit of each food item
array[FOODS] of int: cost = [3, 6, 1, 10];

% Nutrients provided per unit of each food item
array[FOODS] of int: protein  = [2, 18, 2, 18];
array[FOODS] of int: carbs    = [4, 17, 28, 27];
array[FOODS] of int: calories = [218, 290, 298, 158];

% Minimum required nutrients
int: minProtein  = 86;
int: minCarbs    = 120;
int: minCalories = 2435;

% Variables
% Integer number of units chosen for each food item (non-negative)
array[FOODS] of var 0..1000: qty;

% Total cost (bounded with a safe upper bound)
var 0..100000: totalCost;

% Total nutrients (bounded with safe upper bounds)
var 0..100000: totalProtein;
var 0..100000: totalCarbs;
var 0..100000: totalCalories;

% Constraints
% --- Compute totals from chosen quantities ---
constraint totalCost = sum(f in FOODS)(cost[f] * qty[f]);
constraint totalProtein = sum(f in FOODS)(protein[f] * qty[f]);
constraint totalCarbs = sum(f in FOODS)(carbs[f] * qty[f]);
constraint totalCalories = sum(f in FOODS)(calories[f] * qty[f]);

% --- Meet minimum nutritional requirements ---
constraint totalProtein >= minProtein;
constraint totalCarbs >= minCarbs;
constraint totalCalories >= minCalories;

% Objective
solve minimize totalCost;