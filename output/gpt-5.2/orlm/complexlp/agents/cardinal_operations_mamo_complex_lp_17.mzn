% Parameters
% Food items (fixed data embedded as requested)
int: nFoods = 5;
set of int: FOODS = 1..nFoods;

% Cost per unit of each food (in dollars)
array[FOODS] of int: cost = [7, 6, 6, 10, 2]; % Lentils, Rice, Chicken, Beef, Tofu

% Nutritional content per unit of each food
array[FOODS] of int: protein  = [13, 2, 7, 18, 12];
array[FOODS] of int: carbs    = [21, 30, 13, 8, 28];
array[FOODS] of int: calories = [284, 55, 276, 204, 160];

% Minimum required totals
int: minProtein  = 79;
int: minCarbs    = 170;
int: minCalories = 1699;

% Variables
% Number of units of each food to purchase (nonnegative integer quantities)
array[FOODS] of var 0..1000: qty;

% Total cost (objective value)
var 0..100000: totalCost;

% Constraints
% Total cost definition
constraint
  totalCost = sum(f in FOODS)(cost[f] * qty[f]);

% Minimum protein requirement
constraint
  sum(f in FOODS)(protein[f] * qty[f]) >= minProtein;

% Minimum carbohydrates requirement
constraint
  sum(f in FOODS)(carbs[f] * qty[f]) >= minCarbs;

% Minimum calories requirement
constraint
  sum(f in FOODS)(calories[f] * qty[f]) >= minCalories;

% Objective
solve minimize totalCost;