% Parameters
% Food items (fixed list; data embedded)
int: nFoods = 6;
set of int: FOODS = 1..nFoods;

% Indices for readability
int: CHICKEN = 1;
int: RICE    = 2;
int: TUNA    = 3;
int: BEEF    = 4;
int: CORN    = 5;
int: WHEY    = 6;

% Nutrient content per serving (unit) of each food
array[FOODS] of int: protein  = [13, 1, 17, 15, 2, 15];
array[FOODS] of int: carbs    = [27, 1,  2, 18, 19, 11];
array[FOODS] of int: calories = [81, 137, 53, 126, 117, 277];

% Cost per serving of each food
array[FOODS] of int: cost = [1, 9, 2, 9, 4, 6];

% Minimum daily requirements
int: minProtein  = 58;
int: minCarbs    = 148;
int: minCalories = 2454;

% Safe upper bound on servings to keep the model bounded
% Minimum non-zero calories per serving is 53 (tuna), so ceil(2454/53)=47
int: maxServings = ceil(int2float(minCalories) / 53.0);

% Variables
% servings[f] = number of servings of food f to buy/consume
array[FOODS] of var 0..maxServings: servings;

% Total cost to minimize
var int: totalCost;

% Constraints
% Link total cost to chosen servings
constraint
  totalCost_definition:
    totalCost = sum(f in FOODS)(cost[f] * servings[f]);

% Meet minimum protein requirement
constraint
  min_protein_requirement:
    sum(f in FOODS)(protein[f] * servings[f]) >= minProtein;

% Meet minimum carbohydrate requirement
constraint
  min_carbs_requirement:
    sum(f in FOODS)(carbs[f] * servings[f]) >= minCarbs;

% Meet minimum calorie requirement
constraint
  min_calories_requirement:
    sum(f in FOODS)(calories[f] * servings[f]) >= minCalories;

% Objective
solve minimize totalCost;