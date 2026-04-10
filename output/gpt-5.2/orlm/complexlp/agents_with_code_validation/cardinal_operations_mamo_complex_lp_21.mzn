% Parameters
int: nFoods = 6;                         % Number of food options
set of int: FOODS = 1..nFoods;           % Index set for foods

% Food names (for readability / debugging)
array[FOODS] of string: foodName =
  ["Chicken","Rice","Vegetables","Bread","Almonds","Salmon"];

% Nutrient content per unit of each food
array[FOODS] of int: protein  = [16, 11, 1, 6, 2, 19];       % grams protein
array[FOODS] of int: carbs    = [8, 24, 5, 26, 11, 20];      % grams carbohydrates
array[FOODS] of int: calories = [50, 90, 164, 165, 51, 238]; % calories

% Cost per unit of each food
array[FOODS] of int: cost = [2, 3, 3, 2, 4, 10];             % dollars

% Minimum required totals
int: minProtein  = 58;
int: minCarbs    = 150;
int: minCalories = 2392;

% Variables
array[FOODS] of var 0..48: qty;          % Units of each food selected (bounded)
var 0..10000: totalCost;                % Total cost (bounded)

% Constraints

% Link totalCost to chosen quantities and per-unit costs
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