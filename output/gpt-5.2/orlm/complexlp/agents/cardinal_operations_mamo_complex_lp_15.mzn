% Parameters
% Food items (fixed, embedded data)
int: nFoods = 6;
set of int: FOODS = 1..nFoods;

% Index mapping (for readability in comments):
% 1=Eggs, 2=Chicken, 3=Tofu, 4=Salmon, 5=BrownRice, 6=Spinach
array[FOODS] of int: cost     = [10,  9,  2, 10,  8,  1];   % $ per serving
array[FOODS] of int: protein  = [ 1,  4, 13,  8,  7,  8];   % g protein per serving
array[FOODS] of int: carbs    = [13, 10,  9,  3, 13, 16];   % g carbs per serving
array[FOODS] of int: calories = [211,256,273, 54, 93, 52];  % kcal per serving

% Nutritional minimum requirements
int: minProtein  = 60;
int: minCarbs    = 122;
int: minCalories = 2028;

% Variables
% servings[f] = number of servings of food f in the daily plan
% Upper bound 2028 is safe (cannot need more than 2028 servings to reach 2028 calories).
array[FOODS] of var 0..2028: servings;

% total daily cost (upper bound uses worst-case max cost * max servings)
var 0..(max(cost) * 2028): totalCost;

% Constraints
% Link total cost to chosen servings (linear cost accumulation)
constraint
  totalCost = sum(f in FOODS)(cost[f] * servings[f]);

% Meet minimum protein requirement
constraint
  sum(f in FOODS)(protein[f] * servings[f]) >= minProtein;

% Meet minimum carbohydrate requirement
constraint
  sum(f in FOODS)(carbs[f] * servings[f]) >= minCarbs;

% Meet minimum calorie requirement
constraint
  sum(f in FOODS)(calories[f] * servings[f]) >= minCalories;

% Objective
solve minimize totalCost;