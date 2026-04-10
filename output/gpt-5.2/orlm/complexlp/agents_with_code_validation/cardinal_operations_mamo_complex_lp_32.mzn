% Parameters
int: nFoods = 6;
set of int: FOODS = 1..nFoods;

% Food names (readability only; not required for solving)
array[FOODS] of string: foodName =
  ["Pasta","Avocado","Chicken","Tofu","Spinach","Cheese"];

% Nutrient content per unit (serving) of each food
array[FOODS] of int: protein  = [15, 20, 15, 19, 19, 12];
array[FOODS] of int: carbs    = [30, 16,  8,  5, 28, 17];
array[FOODS] of int: calories = [154,111,211, 87, 98,231];

% Cost per unit (serving) of each food
array[FOODS] of int: cost = [3, 8, 7, 2, 9, 10];

% Minimum required totals
int: minProtein  = 73;
int: minCarbs    = 111;
int: minCalories = 2196;

% Variables
% Units/servings of each food to buy (nonnegative integer)
array[FOODS] of var 0..100: x; % 100 is a safe upper bound for this instance

% Total cost
var 0..100000: totalCost;

% Constraints
% --- Link decision variables to total cost ---
constraint
  totalCost = sum(f in FOODS)(cost[f] * x[f]);

% --- Meet minimum protein requirement ---
constraint
  sum(f in FOODS)(protein[f] * x[f]) >= minProtein;

% --- Meet minimum carbohydrate requirement ---
constraint
  sum(f in FOODS)(carbs[f] * x[f]) >= minCarbs;

% --- Meet minimum calorie requirement ---
constraint
  sum(f in FOODS)(calories[f] * x[f]) >= minCalories;

% Objective
solve minimize totalCost;

output [show(totalCost)];