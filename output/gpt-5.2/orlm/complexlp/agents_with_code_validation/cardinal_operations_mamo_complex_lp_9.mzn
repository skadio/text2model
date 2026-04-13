% Parameters
int: nFoods = 8;                         % number of available food items
set of int: FOODS = 1..nFoods;           % index set for foods

% Cost per unit of each food item (in $)
array[FOODS] of int: cost = [7, 7, 1, 9, 6, 7, 2, 6];

% Nutritional content per unit of each food item
array[FOODS] of int: protein  = [12, 10, 11,  8, 16,  4,  4,  4];      % grams
array[FOODS] of int: carbs    = [ 5,  1, 30, 26,  9, 25, 16, 20];      % grams
array[FOODS] of int: calories = [231,210,295,211,232,146,255,205];     % kcal

% Daily nutritional requirements (minimums)
int: reqProtein  = 91;      % grams
int: reqCarbs    = 136;     % grams
int: reqCalories = 1563;    % kcal

% A safe upper bound on servings for each food (enough to meet the largest requirement alone)
int: maxServings = 157;

% Variables
array[FOODS] of var 0..maxServings: servings;  % integer number of servings of each food item
var 0..(maxServings * sum(cost)): totalCost;   % total cost to minimize

% Constraints
% Link totalCost to the chosen servings and per-food costs
constraint
  totalCost = sum(f in FOODS)(cost[f] * servings[f]);

% Meet minimum daily protein requirement
constraint
  sum(f in FOODS)(protein[f] * servings[f]) >= reqProtein;

% Meet minimum daily carbohydrate requirement
constraint
  sum(f in FOODS)(carbs[f] * servings[f]) >= reqCarbs;

% Meet minimum daily calorie requirement
constraint
  sum(f in FOODS)(calories[f] * servings[f]) >= reqCalories;

% Objective
solve minimize totalCost;